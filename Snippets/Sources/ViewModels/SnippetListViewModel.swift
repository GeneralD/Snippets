//
//  SnippetListViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxSwiftExt
import RxOptional
import RxGRDB
import EmptyDataSet_Swift
import Runes
import Fuse

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var contentOffset: AnyObserver<CGPoint> { get }
	var refresherPulled: AnyObserver<()> { get }
	var searchBarText: AnyObserver<String?> { get }
	var pickDocumentTap: AnyObserver<()> { get }
	var viewWillLayoutSubviews: AnyObserver<()> { get }
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SnippetCellModel]> { get }
	var isRefreshing: Observable<Bool> { get }
	var isSearchBarHidden: Observable<Bool> { get }
	var itemSize: Observable<CGSize> { get }
	var presentView: Observable<UIViewController> { get }
	var emptyDataSetView: (EmptyDataSetView) -> Void { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	let contentOffset: AnyObserver<CGPoint>
	let refresherPulled: AnyObserver<()>
	let searchBarText: AnyObserver<String?>
	let pickDocumentTap: AnyObserver<()>
	let viewWillLayoutSubviews: AnyObserver<()>
	
	// MARK: Outputs
	let items: Observable<[SnippetCellModel]>
	let isRefreshing: Observable<Bool>
	let isSearchBarHidden: Observable<Bool>
	let itemSize: Observable<CGSize>
	let presentView: Observable<UIViewController>
	let emptyDataSetView: (EmptyDataSetView) -> Void
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetListModel) {
		// Inputs
		let _itemSelected = PublishRelay<IndexPath>()
		self.itemSelected = _itemSelected.asObserver()
		
		let _contentOffset = PublishRelay<CGPoint>()
		self.contentOffset = _contentOffset.asObserver()
		
		let _refresherPulled = BehaviorRelay<()>(value: ())
		self.refresherPulled = _refresherPulled.asObserver()
		
		let _searchBarText = BehaviorRelay<(String?)>(value: nil)
		self.searchBarText = _searchBarText.asObserver()
		
		let _pickDocumentTap = PublishRelay<()>()
		self.pickDocumentTap = _pickDocumentTap.asObserver()
		
		let _viewWillLayoutSubviews = PublishRelay<()>()
		self.viewWillLayoutSubviews = _viewWillLayoutSubviews.asObserver()
		
		// Outputs
		let _items = BehaviorRelay<[SnippetCellModel]>(value: [])
		self.items = _items.asObservable()
		
		let _isRefreshing = BehaviorSubject<Bool>(value: false)
		self.isRefreshing = _isRefreshing.asObserver()
		
		let _isSearchBarHidden = BehaviorRelay<Bool>(value: true)
		self.isSearchBarHidden = _isSearchBarHidden.asObservable()
		
		let _itemSize = BehaviorRelay<CGSize>(value: .zero)
		self.itemSize = _itemSize.asObservable()
		
		let _presentView = PublishRelay<UIViewController>()
		self.presentView = _presentView.asObservable()
		
		// Bind them
		let loadUrl = _refresherPulled
			.combineLatest(model.documentUrl, resultSelector: *>)
			.share()
		
		let allItems = loadUrl
			.filterNil()
			.flatMap(SQLSnippet.rx.all(url: ))
			.share()
		
		// To remember last value (to check if item is empty in emptyDataSetView)
		let anyItemLoaded = BehaviorRelay<Bool>(value: false)
		allItems
			.map(\.isNotEmpty)
			.bind(to: anyItemLoaded)
			.disposed(by: disposeBag)
		
		_itemSelected
			.map(\.row)
			.filter { $0 < _items.value.count }
			.withLatestFrom(_items) { index, array in array[index].snippet }
			.withLatestFrom(model.documentUrl.unwrap(), resultSelector: SnippetDetailModel.init(snippet: documentUrl: ))
			.map(SnippetDetailViewController.init(with: ))
			.bind(to: _presentView)
			.disposed(by: disposeBag)
		
		_contentOffset
			.map(\.y)
			.ignore(0)
			.map { $0 > 0 }
			.combineLatest(allItems) { $0 || $1.isEmpty }
			.bind(to: _isSearchBarHidden)
			.disposed(by: disposeBag)
		
		_searchBarText
			.replaceNilWith("")
			.filter("")
			.combineLatest(allItems, resultSelector: { $1 })
			.mapMany(SnippetCellModel.init(snippet: ))
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		_searchBarText
			.replaceNilWith("")
			.ignore("")
			.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
			.combineLatest(allItems, resultSelector: { (keyword: $0, items: $1) })
			.flatMapFirst({ Fuse(threshold: 0.3, tokenize: true).rx.search(text: $0.keyword, in: $0.items, scoreSort: .desc) })
			.mapMany(SnippetCellModel.init(snippet: ))
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		// If failed to pick an URL, hide loading indicator
		loadUrl
			.filter { $0 == nil }
			.mapTo(false)
			.bind(to: _isRefreshing)
			.disposed(by: disposeBag)
		
		// If items are loaded, hide loading indicator
		_items
			.mapTo(false)
			.bind(to: _isRefreshing)
			.disposed(by: disposeBag)
		
		_pickDocumentTap
			.mapTo(UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open))
			.do(onNext: _presentView.accept)
			.flatMap(\.rx.didPickDocumentsAt)
			.compactMap(\.first)
			.bind(to: model.documentUrl)
			.disposed(by: disposeBag)
		
		_viewWillLayoutSubviews
			.compactMap { UIApplication.shared.windows.first?.safeAreaInsets }
			.map { insets in CGSize(width: UIScreen.main.bounds.width - insets.left - insets.right, height: 200) }
			.bind(to: _itemSize)
			.disposed(by: disposeBag)
		
		
		emptyDataSetView = { view in
			if anyItemLoaded.value {
				view.titleLabelString(.init(string: R.string.localizable.snippetNoResultTitleLabel()))
					.detailLabelString(.init(string: R.string.localizable.snippetNoResultDetailLabel()))
			} else {
				view.titleLabelString(.init(string: R.string.localizable.snippetFileNotOpenedTitleLabel()))
					.detailLabelString(.init(string: R.string.localizable.snippetFileNotOpenedDetailLabel()))
					.buttonTitle(.init(string: R.string.localizable.snippetFileNotOpenedButtonLabel(), attributes: [.foregroundColor: UIColor.systemGreen]), for: .normal)
					.didTapDataButton { _pickDocumentTap.accept(()) }
			}
		}
	}
}

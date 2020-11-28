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
	var emptyDataSetView: Observable<(EmptyDataSetView) -> ()> { get }
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
	let emptyDataSetView: Observable<(EmptyDataSetView) -> ()>
	
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
		
		let _emptyDataSetView = BehaviorRelay<(EmptyDataSetView) -> Void> { _ in }
		self.emptyDataSetView = _emptyDataSetView.asObservable()
		
		// Bind them
		let loadUrl = _refresherPulled
			.combineLatest(model.documentUrl)
			.map(\.1)
			.share()
		
		let allItems = loadUrl
			.filterNil()
			.flatMap(SQLSnippet.rx.all(url: ))
			.share()
		
		_itemSelected
			.map(\.row)
			.filter { $0 < _items.value.count }
			.withLatestFrom(_items) { $1[$0] }
			.map(\.snippet)
			.withLatestFrom(model.documentUrl.unwrap(), resultSelector: SnippetDetailModel.init(snippet: documentUrl: ))
			.map(SnippetDetailViewController.init(with: ))
			.bind(to: _presentView)
			.disposed(by: disposeBag)
		
		_contentOffset
			.map(\.y)
			.ignore(0)
			.map { $0 > 0 }
			.combineLatest(allItems.map(\.isEmpty), resultSelector: !(||))
			.bind(to: _isSearchBarHidden)
			.disposed(by: disposeBag)
		
		_searchBarText
			.replaceNilWith(.empty)
			.filter(.empty)
			.combineLatest(allItems)
			.map(\.1)
			.mapMany(SnippetCellModel.init(snippet: ))
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		_searchBarText
			.replaceNilWith(.empty)
			.ignore(.empty)
			.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
			.combineLatest(allItems)
			.flatMapLatest { Fuse(threshold: 0.3, tokenize: true).rx.search(text: $0.0, in: $0.1, scoreSort: .desc) }
			.mapMany(SnippetCellModel.init(snippet: ))
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		// If failed to pick an URL, hide loading indicator
		loadUrl
			.filter(.none)
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
		
		allItems
			.map(\.isNotEmpty)
			.map { anyItemLoaded in { view in _ = anyItemLoaded
				? view
				.titleLabelString(.init(string: R.string.localizable.snippetNoResultTitleLabel()))
				.detailLabelString(.init(string: R.string.localizable.snippetNoResultDetailLabel()))
				: view
				.titleLabelString(.init(string: R.string.localizable.snippetFileNotOpenedTitleLabel()))
				.detailLabelString(.init(string: R.string.localizable.snippetFileNotOpenedDetailLabel()))
				.buttonTitle(.init(string: R.string.localizable.snippetFileNotOpenedButtonLabel(), attributes: [.foregroundColor: UIColor.systemGreen]), for: .normal)
				.didTapDataButton { _pickDocumentTap.accept(()) }
			}}
			.bind(to: _emptyDataSetView)
			.disposed(by: disposeBag)
	}
}

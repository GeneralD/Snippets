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
import RxOptional
import RxGRDB
import SwiftyUserDefaults
import EmptyDataSet_Swift

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var contentOffset: AnyObserver<CGPoint> { get }
	var refresherPulled: AnyObserver<()> { get }
	var searchBarText: AnyObserver<String?> { get }
	var pickDocumentTap: AnyObserver<()> { get }
	var viewWillLayoutSubviews: AnyObserver<()> { get }
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
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
	let items: Observable<[SQLSnippet]>
	let isRefreshing: Observable<Bool>
	let isSearchBarHidden: Observable<Bool>
	let itemSize: Observable<CGSize>
	let presentView: Observable<UIViewController>
	let emptyDataSetView: (EmptyDataSetView) -> Void
	
	private let disposeBag = DisposeBag()
	
	init() {
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
		let _items = BehaviorRelay<[SQLSnippet]>(value: [])
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
		let documentUrl = UserDefaults.standard.rx.url(forKey: "documentUrl")
		let loadUrl = _refresherPulled
			.combineLatest(documentUrl) { _, url in url }
			.share()
		
		let allItems = loadUrl
			.filterNil()
			.flatMap(SQLSnippet.rx.all(url: ))
			.share()
		
		// To remember last value (to check if item is empty in emptyDataSetView)
		let anyItemLoaded = BehaviorRelay<Bool>(value: false)
		allItems
			.map { $0.isNotEmpty }
			.bind(to: anyItemLoaded)
			.disposed(by: disposeBag)
		
		_itemSelected
			.filter { _items.value.count > $0.row }
			.map { _items.value[$0.row] }
			.map(SnippetDetailViewController.init(with: ))
			.bind(to: _presentView)
			.disposed(by: disposeBag)
		
		_contentOffset
			.filter { $0.y != 0 }
			.map { $0.y > 0 }
			.combineLatest(allItems) { $0 || $1.isEmpty }
			.bind(to: _isSearchBarHidden)
			.disposed(by: disposeBag)
		
		// Filter items
		allItems
			.combineLatest(_searchBarText.debounce(.milliseconds(300), scheduler: MainScheduler.instance), resultSelector: { items, text in
				guard let str = text, !str.isEmpty else { return items }
				return items.filter { $0.contains(keyword: str) }
			})
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		// If failed to pick an URL, hide loading indicator
		loadUrl
			.filter { $0 == nil }
			.map { _ in false }
			.bind(to: _isRefreshing)
			.disposed(by: disposeBag)
		
		// If items are loaded, hide loading indicator
		_items.map { _ in false }
			.bind(to: _isRefreshing)
			.disposed(by: disposeBag)
		
		_pickDocumentTap
			.map { UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open) }
			.do(onNext: _presentView.accept)
			.flatMap { picker in picker.rx.didPickDocumentsAt }
			.compactMap { $0.first }
			.subscribe(onNext: { url in Defaults.documentUrl = url })
			.disposed(by: disposeBag)
		
		_viewWillLayoutSubviews
			.compactMap { _ in UIApplication.shared.windows.first?.safeAreaInsets }
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
					.buttonTitle(.init(string: R.string.localizable.snippetFileNotOpenedButtonLabel(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]), for: .normal)
					.didTapDataButton { _pickDocumentTap.accept(()) }
			}
		}
	}
}

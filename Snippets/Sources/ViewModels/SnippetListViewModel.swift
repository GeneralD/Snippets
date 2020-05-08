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
import RxGRDB

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var contentOffset: AnyObserver<CGPoint> { get }
	var refresherPulled: AnyObserver<()> { get }
	var searchBarText: AnyObserver<String?> { get }
	var viewWillLayoutSubviews: AnyObserver<UIEdgeInsets> { get }
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
	var present: Observable<(IndexPath, SQLSnippet)?> { get }
	var isRefreshing: Observable<Bool> { get }
	var isSearchBarHidden: Observable<Bool> { get }
	var itemSize: Observable<CGSize> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	let contentOffset: AnyObserver<CGPoint>
	let refresherPulled: AnyObserver<()>
	let searchBarText: AnyObserver<String?>
	let viewWillLayoutSubviews: AnyObserver<UIEdgeInsets>
	
	// MARK: Outputs
	let items: Observable<[SQLSnippet]>
	let present: Observable<(IndexPath, SQLSnippet)?>
	let isRefreshing: Observable<Bool>
	let isSearchBarHidden: Observable<Bool>
	let itemSize: Observable<CGSize>
	
	private let disposeBag = DisposeBag()
	
	init() {
		// Inputs
		let _itemSelected = PublishRelay<IndexPath>()
		self.itemSelected = _itemSelected.asObserver()
		
		let _contentOffset = PublishRelay<CGPoint>()
		self.contentOffset = _contentOffset.asObserver()
		
		let _refresherPulled = PublishRelay<()>()
		self.refresherPulled = _refresherPulled.asObserver()
		
		let _searchBarText = BehaviorRelay<(String?)>(value: nil)
		self.searchBarText = _searchBarText.asObserver()
		
		let _viewWillLayoutSubviews = PublishRelay<UIEdgeInsets>()
		viewWillLayoutSubviews = _viewWillLayoutSubviews.asObserver()
		
		// Outputs
		let _items = BehaviorRelay<[SQLSnippet]>(value: [])
		self.items = _items.asObservable()
		
		self.isRefreshing = _items.map { _ in false }.asObservable()
		
		let _present = BehaviorRelay<(IndexPath, SQLSnippet)?>(value: nil)
		self.present = _present.asObservable()
		
		let _isSearchBarHidden = BehaviorRelay<Bool>(value: true)
		self.isSearchBarHidden = _isSearchBarHidden.asObservable()
		
		let _itemSize = BehaviorRelay<CGSize>(value: .zero)
		self.itemSize = _itemSize.asObservable()
		
		// Bind them
		_itemSelected
			.filter { _items.value.count > $0.row }
			.map { ($0, _items.value[$0.row]) }
			.bind(to: _present)
			.disposed(by: disposeBag)
		
		_contentOffset
			.filter { $0.y != 0 }
			.map { $0.y > 0 }
			.bind(to: _isSearchBarHidden)
			.disposed(by: disposeBag)
		
		_refresherPulled
			.merge(Observable.just(()))
			.flatMap { SQLSnippet.rx.all }
			.combineLatest(_searchBarText.debounce(.milliseconds(300), scheduler: MainScheduler.instance), resultSelector: { items, text in
				guard let str = text, !str.isEmpty else { return items }
				return items.filter { $0.contains(keyword: str) }
			})
			.bind(to: _items)
			.disposed(by: disposeBag)
		
		_viewWillLayoutSubviews
			.map { insets in CGSize(width: UIScreen.main.bounds.width - insets.left - insets.right, height: 200) }
			.bind(to: _itemSize)
			.disposed(by: disposeBag)
	}
}

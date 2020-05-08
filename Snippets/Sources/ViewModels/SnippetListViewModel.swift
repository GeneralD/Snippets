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
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
	var present: Observable<(IndexPath, SQLSnippet)?> { get }
	var isRefreshing: Observable<Bool> { get }
	var isSearchBarHidden: Observable<Bool> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	let contentOffset: AnyObserver<CGPoint>
	let refresherPulled: AnyObserver<()>
	let searchBarText: AnyObserver<String?>
	
	// MARK: Outputs
	let items: Observable<[SQLSnippet]>
	let present: Observable<(IndexPath, SQLSnippet)?>
	let isRefreshing: Observable<Bool>
	let isSearchBarHidden: Observable<Bool>
	
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
		
		// Outputs
		let _items = BehaviorRelay<[SQLSnippet]>(value: [])
		self.items = _items.asObservable()
		
		self.isRefreshing = _items.map { _ in false }.asObservable()
		
		let _present = BehaviorRelay<(IndexPath, SQLSnippet)?>(value: nil)
		self.present = _present.asObservable()
		
		let _isSearchBarHidden = BehaviorRelay<Bool>(value: true)
		self.isSearchBarHidden = _isSearchBarHidden.asObservable()
		
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
			.compactMap { R.file.snippetsDash.database }
			.flatMap { db in db.rx.read { try SQLSnippet.fetchAll($0) } }
			.combineLatest(_searchBarText.debounce(.milliseconds(300), scheduler: MainScheduler.instance), resultSelector: { items, text in
				guard let str = text, !str.isEmpty else { return items }
				return items.filter { $0.contains(keyword: str) }
			})
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
}

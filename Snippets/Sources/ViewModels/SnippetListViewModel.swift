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
import GRDB
import RxGRDB

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var refresherPulled: AnyObserver<()> { get }
	var searchBarText: AnyObserver<String?> { get }
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
	var present: Observable<(IndexPath, SQLSnippet)?> { get }
	var isRefreshing: Observable<Bool> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	let refresherPulled: AnyObserver<()>
	let searchBarText: AnyObserver<String?>
	
	// MARK: Outputs
	let items: Observable<[SQLSnippet]>
	let present: Observable<(IndexPath, SQLSnippet)?>
	let isRefreshing: Observable<Bool>
	
	private let disposeBag = DisposeBag()
	
	init() {
		// Inputs
		let _itemSelected = PublishRelay<IndexPath>()
		self.itemSelected = _itemSelected.asObserver()
		
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
		
		// Bind them
		_itemSelected
			.filter { _items.value.count > $0.row }
			.map { ($0, _items.value[$0.row]) }
			.bind(to: _present)
			.disposed(by: disposeBag)
		
		_refresherPulled
			.merge(Observable.just(()))
			.compactMap { self.database }
			.flatMap { db in db.rx.read { try SQLSnippet.fetchAll($0) } }
			.combineLatest(_searchBarText.debounce(.milliseconds(300), scheduler: MainScheduler.instance), resultSelector: { items, text in
				guard let str = text, !str.isEmpty else { return items }
				return items.filter { $0.title?.range(of: str, options: [.caseInsensitive, .widthInsensitive]) != nil || $0.body?.range(of: str, options: [.caseInsensitive, .widthInsensitive]) != nil || $0.syntax?.range(of: str, options: [.caseInsensitive, .widthInsensitive]) != nil }
			})
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
	
	private var database: DatabaseQueue? {
		guard let path = Bundle.main.path(forResource: "Snippets", ofType: "dash") else { return nil }
		return try? DatabaseQueue(path: path)
	}
}

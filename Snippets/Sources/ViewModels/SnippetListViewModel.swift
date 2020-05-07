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
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
	var present: Observable<SQLSnippet?> { get }
	var isRefreshing: Observable<Bool> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	let refresherPulled: AnyObserver<()>
	
	// MARK: Outputs
	let items: Observable<[SQLSnippet]>
	let present: Observable<SQLSnippet?>
	let isRefreshing: Observable<Bool>
	
	private let disposeBag = DisposeBag()
	
	init() {
		// Inputs
		let _itemSelected = PublishRelay<IndexPath>()
		self.itemSelected = _itemSelected.asObserver()
		
		let _refresherPulled = PublishRelay<()>()
		self.refresherPulled = _refresherPulled.asObserver()
		
		// Outputs
		let _items = BehaviorRelay<[SQLSnippet]>(value: [])
		self.items = _items.asObservable()
		
		self.isRefreshing = _items.map { _ in false }.asObservable()
		
		let _present = BehaviorRelay<SQLSnippet?>(value: nil)
		self.present = _present.asObservable()
		
		// Bind them
		_itemSelected
			.map { $0.row }
			.filter { _items.value.count > $0 }
			.map { _items.value[$0] }
			.bind(to: _present)
			.disposed(by: disposeBag)
		
		Observable.merge(Observable.just(()), _refresherPulled.asObservable())
			.compactMap { self.database }
			.flatMap { db in db.rx.read { try SQLSnippet.fetchAll($0) } }
			.asObservable()
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
	
	private var database: DatabaseQueue? {
		guard let path = Bundle.main.path(forResource: "Snippets", ofType: "dash") else { return nil }
		return try? DatabaseQueue(path: path)
	}
}

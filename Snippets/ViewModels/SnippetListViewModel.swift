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
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SQLSnippet]> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	let itemSelected: AnyObserver<IndexPath>
	
	// MARK: Outputs
	let items: Observable<[SQLSnippet]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let _itemSelected = PublishRelay<IndexPath>()
		self.itemSelected = AnyObserver<IndexPath> { event in
			guard case .next(let element) = event else { return }
			_itemSelected.accept(element)
		}
		
		let _items = BehaviorRelay<[SQLSnippet]>(value: [])
		self.items = _items.asObservable()
		
		database?.rx.read { db in try SQLSnippet.fetchAll(db) }
			.asObservable()
			.bind(to: _items)
			.disposed(by: disposeBag)
	}
	
	var database: DatabaseQueue? {
		guard let path = Bundle.main.path(forResource: "Snippets", ofType: "dash") else { return nil }
		return try? DatabaseQueue(path: path)
	}
}

//
//  SQLSnippetReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift
import GRDB
import RxGRDB

extension SQLSnippet: ReactiveCompatible {}

extension Reactive where Base: SQLSnippet {
	var tags: Observable<[String]> {
		guard let database = database else { return Observable.error(NSError()) }
		return database.rx.read { db in try SQLTagsIndex.filter(Column("sid") == self.base.sid).fetchAll(db) }
			.compactMap { items in items.compactMap { $0.tid } }
			.asObservable()
			.flatMap { tids in database.rx.read { db in try SQLTag.filter(tids.contains(Column("tid"))).fetchAll(db) } }
			.map { items in items.compactMap { $0.tag } }
			.asObservable()
	}
	
	private var database: DatabaseQueue? {
		guard let path = Bundle.main.path(forResource: "Snippets", ofType: "dash") else { return nil }
		return try? DatabaseQueue(path: path)
	}
}

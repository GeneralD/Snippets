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
		Base.rx.database
			.flatMap { dbQueue in dbQueue.rx.read { db in
				let tids = try SQLTagsIndex.filter(Column("sid") == self.base.sid).fetchAll(db).compactMap { o in o.tid }
				return try SQLTag.filter(tids.contains(Column("tid"))).fetchAll(db).compactMap { o in o.tag }
				}}
			.asObservable()
	}
	
	static var all: Observable<[SQLSnippet]> {
		database
			.flatMap { dbQueue in dbQueue.rx.read { db in
				try SQLSnippet.order(Column("syntax")).fetchAll(db)
				}}
			.asObservable()
	}
	
	private static var database: Observable<DatabaseQueue> {
		guard let database = R.file.snippetsDash.database else { return Observable.error(NSError()) }
		return Observable.just(database)
	}
}

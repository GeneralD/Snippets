//
//  SQLSnippetReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import GRDB
import RxGRDB

extension SQLSnippet: ReactiveCompatible {}

extension Reactive where Base: SQLSnippet {
	
	func tags(url: URL) -> Observable<[String]> {
		tags(path: url.absoluteString)
	}
	
	func tags(path: String) -> Observable<[String]> {
		(try? DatabaseQueue(path: path)).asObservable()
			.flatMap { dbQueue in dbQueue.rx.read { db in
				let tids = try SQLTagsIndex.filter(Column("sid") == self.base.sid).fetchAll(db).compactMap { o in o.tid }
				return try SQLTag.filter(tids.contains(Column("tid"))).fetchAll(db).compactMap { o in o.tag }
				}}
			.asObservable()
	}
	
	static func all(url: URL) -> Observable<[SQLSnippet]> {
		all(path: url.absoluteString)
	}
	
	static func all(path: String) -> Observable<[SQLSnippet]> {
		(try? DatabaseQueue(path: path)).asObservable()
			.flatMap { dbQueue in dbQueue.rx.read { db in
				try SQLSnippet.order(Column("syntax")).fetchAll(db)
				}}
			.asObservable()
	}
}

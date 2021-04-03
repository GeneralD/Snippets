//
//  SQLSnippet+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Entity
import Foundation
import GRDB
import RxGRDB
import RxSwift

extension SQLSnippet: ReactiveCompatible {}

extension Reactive where Base: SQLSnippet {
	enum GRDBError: Error {
		case databaseError
	}

	func tags(url: URL) -> Single<[String]> {
		tags(path: url.absoluteString)
	}

	func tags(path: String) -> Single<[String]> {
		guard let queue = try? DatabaseQueue(path: path) else { return .error(GRDBError.databaseError) }
		return queue.rx.read { db in
			let tids = try SQLTagsIndex.filter(Column("sid") == self.base.sid).fetchAll(db).compactMap(\.tid)
			return try SQLTag.filter(tids.contains(Column("tid"))).fetchAll(db).compactMap(\.tag)
		}
	}

	static func all(url: URL) -> Single<[SQLSnippet]> {
		all(path: url.absoluteString)
	}

	static func all(path: String) -> Single<[SQLSnippet]> {
		guard let queue = try? DatabaseQueue(path: path) else { return .error(GRDBError.databaseError) }
		return queue.rx.read { db in
			try SQLSnippet.order(Column("syntax")).fetchAll(db)
		}
	}
}

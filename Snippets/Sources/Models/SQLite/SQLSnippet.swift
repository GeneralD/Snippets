//
//  SQLSnippet.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB
import Fuse

class SQLSnippet: FetchableRecord {
	
	var sid: Int64?
	var title: String?
	var body: String?
	var syntax: String?
	var usageCount: Int?
	
	required init(row: Row) {
		sid = row["sid"]
		title = row["title"]
		body = row["body"]
		syntax = row["syntax"]
		usageCount = row["usageCount"]
	}
}

extension SQLSnippet: TableRecord {
	static var databaseTableName: String { "snippets" }
}

extension SQLSnippet: PersistableRecord {
	func encode(to container: inout PersistenceContainer) {
		container["sid"] = sid
		container["title"] = title
		container["body"] = body
		container["syntax"] = syntax
		container["usageCount"] = usageCount
	}
}

extension SQLSnippet: Fuseable {
	var properties: [FuseProperty] {
		// Fuse is a bit strange, smaller weight takes better score
		[title.map { FuseProperty(name: $0, weight: 0.1) },
		 body.map { FuseProperty(name: $0, weight: 0.8) },
		 syntax.map { FuseProperty(name: $0, weight: 0.1) }].compactMap { $0 }
	}
}

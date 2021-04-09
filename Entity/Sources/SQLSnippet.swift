//
//  SQLSnippet.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

public class SQLSnippet: FetchableRecord {
	public var sid: Int64?
	public var title: String?
	public var body: String?
	public var syntax: String?
	public var usageCount: Int?

	public required init(row: Row) {
		sid = row["sid"]
		title = row["title"]
		body = row["body"]
		syntax = row["syntax"]
		usageCount = row["usageCount"]
	}
}

extension SQLSnippet: TableRecord {
	public static var databaseTableName: String { "snippets" }
}

extension SQLSnippet: PersistableRecord {
	public func encode(to container: inout PersistenceContainer) {
		container["sid"] = sid
		container["title"] = title
		container["body"] = body
		container["syntax"] = syntax
		container["usageCount"] = usageCount
	}
}

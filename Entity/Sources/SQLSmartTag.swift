//
//  SQLSmartTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

public class SQLSmartTag: FetchableRecord {
	public var stid: Int64?
	public var name: String?
	public var query: String?

	public required init(row: Row) {
		stid = row["stid"]
		name = row["name"]
		query = row["query"]
	}
}

extension SQLSmartTag: TableRecord {
	public static var databaseTableName: String { "smartTags" }
}

extension SQLSmartTag: PersistableRecord {
	public func encode(to container: inout PersistenceContainer) {
		container["stid"] = stid
		container["name"] = name
		container["query"] = query
	}
}

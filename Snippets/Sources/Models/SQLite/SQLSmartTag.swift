//
//  SQLSmartTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLSmartTag: FetchableRecord {

	var stid: Int64?
	var name: String?
	var query: String?
	
	required init(row: Row) {
		stid = row["stid"]
		name = row["name"]
		query = row["query"]
	}
}

extension SQLSmartTag: TableRecord {
	static var databaseTableName: String { "smartTags" }
}

extension SQLSmartTag: PersistableRecord {
	func encode(to container: inout PersistenceContainer) {
		container["stid"] = stid
		container["name"] = name
		container["query"] = query
	}
}

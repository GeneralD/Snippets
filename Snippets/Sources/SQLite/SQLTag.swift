//
//  SQLTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLTag: FetchableRecord {

	var tid: Int64?
	var tag: String?
	
	required init(row: Row) {
		tid = row["tid"]
		tag = row["tag"]
	}
}

extension SQLTag: TableRecord {
	static var databaseTableName: String { "tags" }
}

extension SQLTag: PersistableRecord {
	func encode(to container: inout PersistenceContainer) {
		container["tid"] = tid
		container["tag"] = tag
	}
}

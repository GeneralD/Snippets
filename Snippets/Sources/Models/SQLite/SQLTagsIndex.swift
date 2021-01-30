//
//  SQLTagsIndex.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLTagsIndex: FetchableRecord {
	var tid: Int64?
	var sid: Int?

	required init(row: Row) {
		tid = row["tid"]
		sid = row["sid"]
	}
}

extension SQLTagsIndex: TableRecord {
	static var databaseTableName: String { "tagsIndex" }
}

extension SQLTagsIndex: PersistableRecord {
	func encode(to container: inout PersistenceContainer) {
		container["tid"] = tid
		container["sid"] = sid
	}
}

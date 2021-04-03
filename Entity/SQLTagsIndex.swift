//
//  SQLTagsIndex.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

public class SQLTagsIndex: FetchableRecord {
	public var tid: Int64?
	public var sid: Int?

	public required init(row: Row) {
		tid = row["tid"]
		sid = row["sid"]
	}
}

extension SQLTagsIndex: TableRecord {
	public static var databaseTableName: String { "tagsIndex" }
}

extension SQLTagsIndex: PersistableRecord {
	public func encode(to container: inout PersistenceContainer) {
		container["tid"] = tid
		container["sid"] = sid
	}
}

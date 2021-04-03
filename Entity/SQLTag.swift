//
//  SQLTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

public class SQLTag: FetchableRecord {
	public var tid: Int64?
	public var tag: String?

	public required init(row: Row) {
		tid = row["tid"]
		tag = row["tag"]
	}
}

extension SQLTag: TableRecord {
	public static var databaseTableName: String { "tags" }
}

extension SQLTag: PersistableRecord {
	public func encode(to container: inout PersistenceContainer) {
		container["tid"] = tid
		container["tag"] = tag
	}
}

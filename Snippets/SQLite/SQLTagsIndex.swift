//
//  SQLTagsIndex.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLTagsIndex: Record {
	
	var tid: Int64?
	var sid: Int64?
	
	override class var databaseTableName: String { "tagsIndex" }
}

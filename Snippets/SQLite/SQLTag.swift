//
//  SQLTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLTag: Record {
	
	var tid: Int64?
	var tag: String?
	
	override class var databaseTableName: String { "tags" }
}

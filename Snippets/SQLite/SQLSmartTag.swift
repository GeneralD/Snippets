//
//  SQLSmartTag.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLSmartTag: Record {
	
	var stid: Int64?
	var name: String?
	var query: String?
	
	override class var databaseTableName: String { "smartTags" }
}

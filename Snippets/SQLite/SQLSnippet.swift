//
//  SQLSnippet.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import GRDB

class SQLSnippet: Record {

	var sid: Int64?
	var title: String?
	var body: String?
	var syntax: String?
	var usageCount: Int?
	
	override class var databaseTableName: String { "snippets" }
}

//
//  FileResourceTypeExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Rswift
import GRDB

extension FileResourceType {
	var database: DatabaseQueue? {
		guard let path = path() else { return nil }
		return try? DatabaseQueue(path: path)
	}
}

//
//  StringExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

enum Surrounder {
	case parentheses
	case braces
	case squareBrackets
	case angleBrackets
}

extension String {
	func surrounded(by surrounder: Surrounder) -> String {
		switch surrounder {
		case .parentheses:
			return "(\(self))"
		case .braces:
			return "{\(self)}"
		case .squareBrackets:
			return "[\(self)]"
		case .angleBrackets:
			return "<\(self)>"
		}
	}
}

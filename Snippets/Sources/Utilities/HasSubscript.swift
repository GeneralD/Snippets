//
//  HasSubscript.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/28.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

protocol HasSubscript {
	associatedtype Element
	subscript(_ index: Int) -> Element { get set }
}

extension HasSubscript {
	func elementAt(_ index: Int) -> Element {
		return self[index]
	}
}

extension Array: HasSubscript {}

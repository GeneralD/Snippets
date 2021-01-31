//
//  SnippetCellModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/09/04.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

/// @mockable
protocol SnippetCellModelProtocol {
	var snippet: SQLSnippet { get }
}

struct SnippetCellModel: SnippetCellModelProtocol {
	let snippet: SQLSnippet
}

//
//  SnippetDetailModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/09/04.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

/// @mockable
protocol SnippetDetailModelProtocol {
	var snippet: SQLSnippet { get }
	var documentUrl: URL { get }
}

struct SnippetDetailModel: SnippetDetailModelProtocol {
	let snippet: SQLSnippet
	let documentUrl: URL
}

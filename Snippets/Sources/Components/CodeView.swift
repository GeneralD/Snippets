//
//  CodeView.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Sourceful

class CodeView: SyntaxTextView, SyntaxTextViewDelegate {

	private static let sharedTheme = PastelSourceColorTheme()
	private static let sharedLexer =  DashLexer(baseLexer: SwiftLexer())
	
	override func awakeFromNib() {
		delegate = self
		theme = type(of: self).sharedTheme
	}
	
	func lexerForSource(_ source: String) -> Lexer {
		type(of: self).sharedLexer
	}
}

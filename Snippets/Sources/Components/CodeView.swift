//
//  CodeView.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Sourceful

@IBDesignable
class CodeView: SyntaxTextView, SyntaxTextViewDelegate {
	private static let sharedTheme = PastelSourceColorTheme()
	private static let sharedLexer = DashLexer(baseLexer: SwiftLexer())

	override func awakeFromNib() {
		super.awakeFromNib()
		delegate = self
		theme = Self.sharedTheme
	}

	func lexerForSource(_ source: String) -> Lexer {
		Self.sharedLexer
	}

	@IBInspectable var isEditable: Bool {
		get { contentTextView.isEditable }
		set { contentTextView.isEditable = newValue }
	}
}

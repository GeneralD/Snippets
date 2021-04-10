//
//  CodeView.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Sourceful

@IBDesignable
public class CodeView: SyntaxTextView, SyntaxTextViewDelegate {
	private static let sharedTheme = PastelSourceColorTheme()
	private static let sharedLexer = DashLexer(baseLexer: SwiftLexer())

	override public func awakeFromNib() {
		super.awakeFromNib()
		delegate = self
		theme = Self.sharedTheme
	}

	public func lexerForSource(_ source: String) -> Lexer {
		Self.sharedLexer
	}

	@IBInspectable public var isEditable: Bool {
		get { contentTextView.isEditable }
		set { contentTextView.isEditable = newValue }
	}
}

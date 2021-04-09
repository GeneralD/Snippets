//
//  PastelSourceColorTheme.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import Sourceful

struct PastelSourceColorTheme: SourceCodeTheme {
	let lineNumbersStyle: LineNumbersStyle? = .init(font: Font(name: "Menlo", size: 13)!, textColor: R.color.codeLineNumberColor()!)

	let gutterStyle: GutterStyle = .init(backgroundColor: R.color.codeGutterColor()!, minimumWidth: 32)

	let font = Font(name: "Menlo", size: 12)!

	let backgroundColor: Color = R.color.codeBackgroundColor()!

	func globalAttributes() -> [NSAttributedString.Key: Any] {
		[.font: font, .foregroundColor: R.color.codeForegroundColor()!]
	}

	func color(for syntaxColorType: SourceCodeTokenType) -> Color {
		switch syntaxColorType {
		case .plain:
			return R.color.codePlainColor()!

		case .number:
			return R.color.codeNumberColor()!

		case .string:
			return R.color.codeStringColor()!

		case .identifier:
			return R.color.codeIdentifierColor()!

		case .keyword:
			return R.color.codeKeywordColor()!

		case .comment:
			return R.color.codeCommentColor()!

		case .editorPlaceholder:
			return backgroundColor
		}
	}
}

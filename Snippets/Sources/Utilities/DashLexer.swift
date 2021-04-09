//
//  DashLexer.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import Sourceful

class DashLexer: SourceCodeRegexLexer {
	private let baseLexer: RegexLexer
	private let delimiter: String
	private let enableKeywords: Bool
	private let keywords = ["@clipboard", "@cursor", "@time", "@date"]

	init(baseLexer: RegexLexer, delimiter: String = "__", enableKeywords: Bool = false) {
		self.baseLexer = baseLexer
		self.delimiter = delimiter
		self.enableKeywords = enableKeywords
	}

	func generators(source: String) -> [TokenGenerator] {
		let dashGenerators = [
			regexGenerator("\(delimiter)[^\(delimiter)|\\n]*\(delimiter)", tokenType: .editorPlaceholder),
			keywordGenerator(enableKeywords ? keywords : [], tokenType: .editorPlaceholder)
		].compactMap { $0 }
		let baseGenerators = baseLexer.generators(source: source)
		return baseGenerators + dashGenerators
	}
}

private extension RegexLexer {
	func regexGenerator(_ pattern: String, options: NSRegularExpression.Options = [], transformer: @escaping TokenTransformer) -> TokenGenerator? {
		guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
			return nil
		}
		return .regex(RegexTokenGenerator(regularExpression: regex, tokenTransformer: transformer))
	}
}

private extension SourceCodeRegexLexer {
	func regexGenerator(_ pattern: String, options: NSRegularExpression.Options = [], tokenType: SourceCodeTokenType) -> TokenGenerator? {
		regexGenerator(pattern, options: options, transformer: { range -> Token in
			SimpleSourceCodeToken(type: tokenType, range: range)
		})
	}

	func keywordGenerator(_ words: [String], tokenType: SourceCodeTokenType) -> TokenGenerator {
		.keywords(KeywordTokenGenerator(keywords: words, tokenTransformer: { range -> Token in
			SimpleSourceCodeToken(type: tokenType, range: range)
		}))
	}
}

private protocol SourceCodeToken: Token {
	var type: SourceCodeTokenType { get }
}

private struct SimpleSourceCodeToken: SourceCodeToken {
	let type: SourceCodeTokenType
	let range: Range<String.Index>
}

private extension SourceCodeToken {
	var isEditorPlaceholder: Bool {
		type == .editorPlaceholder
	}

	var isPlain: Bool {
		type == .plain
	}
}

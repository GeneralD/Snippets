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
	
	init(baseLexer: RegexLexer) {
		self.baseLexer = baseLexer
	}
	
	func generators(source: String) -> [TokenGenerator] {
		let delimiter = "__"
		let dashGenerators = [
			regexGenerator("\(delimiter)[^\(delimiter)|\\n]*\(delimiter)", tokenType: .editorPlaceholder),
			//			keywordGenerator(["@clipboard", "@cursor", "@time", "@date"], tokenType: .editorPlaceholder)
		].compactMap { $0 }
		let baseGenerators = baseLexer.generators(source: source)
		return baseGenerators + dashGenerators
	}
}

fileprivate extension RegexLexer {
	func regexGenerator(_ pattern: String, options: NSRegularExpression.Options = [], transformer: @escaping TokenTransformer) -> TokenGenerator? {
		guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
			return nil
		}
		return .regex(RegexTokenGenerator(regularExpression: regex, tokenTransformer: transformer))
	}
}

fileprivate extension SourceCodeRegexLexer {
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

fileprivate protocol SourceCodeToken: Token {
	var type: SourceCodeTokenType { get }
}

fileprivate struct SimpleSourceCodeToken: SourceCodeToken {
	let type: SourceCodeTokenType
	let range: Range<String.Index>
}

fileprivate extension SourceCodeToken {
	var isEditorPlaceholder: Bool {
		type == .editorPlaceholder
	}
	
	var isPlain: Bool {
		type == .plain
	}
}

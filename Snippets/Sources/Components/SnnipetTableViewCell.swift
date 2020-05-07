//
//  SnnipetTableViewCell.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import Sourceful

class SnnipetTableViewCell: UITableViewCell {
	
	@IBOutlet private weak var mainView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var codeTextView: SyntaxTextView!
	@IBOutlet private weak var syntaxLabel: UILabel!
	@IBOutlet private weak var contentPaddingTopConstraint: NSLayoutConstraint!
	
	private static let sharedTheme = PastelSourceColorTheme()
	
	func apply(title: String, code: String, language: String, isFirstRow: Bool) {
		titleLabel.text = title
		codeTextView.text = code
		syntaxLabel.text = language
		syntaxLabel.isHidden = language.isEmpty
		syntaxLabel.backgroundColor = UIColor.themeColor(for: language).comfortable
		contentPaddingTopConstraint.constant = isFirstRow ? 8 : 0
	}
	
	override func awakeFromNib() {
		mainView.layer.masksToBounds = true
		mainView.layer.cornerRadius = 8
		
		codeTextView.delegate = self
		codeTextView.theme = type(of: self).sharedTheme
		codeTextView.layer.masksToBounds = true
		codeTextView.layer.cornerRadius = 8
		
		syntaxLabel.textColor = .white
		syntaxLabel.layer.masksToBounds = true
		syntaxLabel.layer.cornerRadius = syntaxLabel.frame.height / 3
	}
}

extension SnnipetTableViewCell: SyntaxTextViewDelegate {
	
	private static let sharedLexer =  DashLexer(baseLexer: SwiftLexer())
	
	func lexerForSource(_ source: String) -> Lexer {
		type(of: self).sharedLexer
	}
}

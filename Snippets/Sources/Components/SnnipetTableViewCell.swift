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
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var codeTextView: SyntaxTextView!
	@IBOutlet weak var syntaxLabel: UILabel!

	private static let sharedTheme = PastelSourceColorTheme()
	
	override func awakeFromNib() {
		codeTextView.delegate = self
		codeTextView.theme = type(of: self).sharedTheme
		codeTextView.layer.masksToBounds = true
		codeTextView.layer.cornerRadius = 8
		
		syntaxLabel.textColor = .white
		syntaxLabel.backgroundColor = .systemBlue
		syntaxLabel.layer.masksToBounds = true
		syntaxLabel.layer.cornerRadius = 8
	}
}

extension SnnipetTableViewCell: SyntaxTextViewDelegate {
	
	private static let sharedLexer =  DashLexer(baseLexer: SwiftLexer())
	
	func lexerForSource(_ source: String) -> Lexer {
		type(of: self).sharedLexer
	}
}

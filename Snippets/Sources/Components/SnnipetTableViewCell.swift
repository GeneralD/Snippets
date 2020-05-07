//
//  SnnipetTableViewCell.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit

class SnnipetTableViewCell: UITableViewCell {
	
	@IBOutlet private weak var mainView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var codeView: CodeView!
	@IBOutlet private weak var syntaxLabel: UILabel!
	@IBOutlet private weak var contentPaddingTopConstraint: NSLayoutConstraint!
		
	func apply(title: String, code: String, language: String, isFirstRow: Bool) {
		titleLabel.text = title
		codeView.text = code
		syntaxLabel.text = language
		syntaxLabel.isHidden = language.isEmpty
		syntaxLabel.backgroundColor = UIColor.themeColor(for: language).comfortable
		contentPaddingTopConstraint.constant = isFirstRow ? 8 : 0
	}
	
	override func awakeFromNib() {
		mainView.layer.masksToBounds = true
		mainView.layer.cornerRadius = 8
		
		codeView.layer.masksToBounds = true
		codeView.layer.cornerRadius = 8
		
		syntaxLabel.textColor = .white
		syntaxLabel.layer.masksToBounds = true
		syntaxLabel.layer.cornerRadius = syntaxLabel.frame.height / 3
	}
}

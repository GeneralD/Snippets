//
//  SnippetCollectionViewCell.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxCells
import Reusable

class SnippetCollectionViewCell: UICollectionViewCell {

	@IBOutlet private weak var mainView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var codeView: CodeView!
	@IBOutlet private weak var syntaxLabel: UILabel!
	@IBOutlet private weak var contentPaddingTopConstraint: NSLayoutConstraint!
	
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

extension SnippetCollectionViewCell: NibLoadable, Reusable {}

extension SnippetCollectionViewCell: Configurable {
	func configure(with model: (offset: Int, element: SQLSnippet)) {
		let language = model.element.syntax ?? ""
		titleLabel.text = model.element.title
		codeView.text = model.element.body ?? ""
		syntaxLabel.text = language
		syntaxLabel.isHidden = language.isEmpty
		syntaxLabel.backgroundColor = UIColor.themeColor(for: language).comfortable
		contentPaddingTopConstraint.constant = model.offset == 0 ? 8 : 0
	}
}

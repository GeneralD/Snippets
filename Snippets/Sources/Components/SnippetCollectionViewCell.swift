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

	@IBOutlet private weak var cardView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var codeView: CodeView!
	@IBOutlet private weak var syntaxLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Enable itemSelected detection even on ScrollView in the cell
		codeView.contentTextView.isUserInteractionEnabled = false
		contentView.addGestureRecognizer(codeView.contentTextView.panGestureRecognizer)
	}
}

extension SnippetCollectionViewCell: NibLoadable, Reusable {}

extension SnippetCollectionViewCell: Configurable {
	func configure(with model: (offset: Int, element: SQLSnippet)) {
		titleLabel.text = model.element.title
		codeView.text = model.element.body ?? ""
		
		let language = model.element.syntax ?? ""
		syntaxLabel.text = language
		syntaxLabel.isHidden = language.isEmpty
		
		let color = UIColor.themeColor(for: language).comfortable
		syntaxLabel.backgroundColor = color
		cardView.backgroundColor = color.adjustedAlpha(amount: -0.7)
	}
}

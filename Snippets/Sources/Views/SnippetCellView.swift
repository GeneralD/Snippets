//
//  SnippetCellView.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxCells
import RxSwift
import RxCocoa
import RxBinding
import Reusable

class SnippetCellView: UICollectionViewCell {
	
	private typealias Input = SnippetCellViewModelInput
	private typealias Output = SnippetCellViewModelOutput
	
	@IBOutlet private weak var cardView: UIView!
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var codeView: CodeView!
	@IBOutlet private weak var syntaxLabel: UILabel!
	@IBOutlet private weak var copyButton: UIButton!
	
	private var input: Input!
	private var output: Output!
	private var disposeBag: DisposeBag!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Enable itemSelected detection even on ScrollView in the cell
		codeView.contentTextView.isUserInteractionEnabled = false
		contentView.addGestureRecognizer(codeView.contentTextView.panGestureRecognizer)
	}
}

extension SnippetCellView: NibLoadable, Reusable {}

extension SnippetCellView: Configurable {
	
	func configure(with model: SnippetCellModel) {
		let viewModel = SnippetCellViewModel(model: model)
		input = viewModel
		output = viewModel
		
		// Unbind all
		disposeBag = .init()
		
		disposeBag ~
			copyButton.rx.tap ~> input.copyButtonTap
		
		disposeBag ~
			output.titleText ~> titleLabel.rx.text ~
			output.codeText ~> codeView.rx.text ~
			output.languageText ~> syntaxLabel.rx.text ~
			output.languageHidden ~> syntaxLabel.rx.isHidden ~
			output.languageBackgroundColor ~> syntaxLabel.rx.backgroundColor ~
			output.contentViewBackgroundColor ~> cardView.rx.backgroundColor
	}
}

//
//  SnippetDetailViewController.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxBinding
import TagListView
import Instantiate
import InstantiateStandard

class SnippetDetailViewController: UIViewController, StoryboardInstantiatable {
	
	private typealias Input = SnippetDetailViewModelInput
	private typealias Output = SnippetDetailViewModelOutput
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var tagsView: TagListView!
	@IBOutlet private weak var codeView: CodeView!
	@IBOutlet private weak var copyButton: UIButton!
	
	private var input: Input!
	private var output: Output!
	private let disposeBag = DisposeBag()
	
	func inject(_ dependency: SnippetDetailModel) {
		let viewModel = SnippetDetailViewModel(model: dependency)
		input = viewModel
		output = viewModel
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Bind inputs
		disposeBag ~
			copyButton.rx.tap ~> input.copyButtonTap
		
		// Bind outputs
		disposeBag ~
			output.title ~> titleLabel.rx.text ~
			output.code ~> codeView.rx.text ~
			output.tags ~> tagsView.rx.tags
	}
}

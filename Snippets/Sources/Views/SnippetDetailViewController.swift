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
	
	typealias Input = SnippetDetailViewModelInput
	typealias Output = SnippetDetailViewModelOutput
	typealias Dependency = SQLSnippet
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tagsView: TagListView!
	@IBOutlet weak var codeView: CodeView!
	@IBOutlet weak var copyButton: UIButton!
	
	private var input: Input!
	private var output: Output!
	private let disposeBag = DisposeBag()
	
	func inject(_ dependency: SQLSnippet) {
		let viewModel = SnippetDetailViewModel(model: dependency)
		self.input = viewModel
		self.output = viewModel
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

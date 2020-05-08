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
import TagListView

class SnippetDetailViewController: UIViewController {
	
	typealias Input = SnippetDetailViewModelInput
	typealias Output = SnippetDetailViewModelOutput
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tagsView: TagListView!
	@IBOutlet weak var codeView: CodeView!
	
	private let input: Input
	private let output: Output
	private let disposeBag = DisposeBag()
	
	init(viewModel: Input & Output = SnippetDetailViewModel()) {
		self.input = viewModel
		self.output = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		let viewModel = SnippetDetailViewModel()
		self.input = viewModel
		self.output = viewModel
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
}

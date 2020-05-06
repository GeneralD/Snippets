//
//  SnippetListViewController.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SnippetListViewController: UIViewController {
	
	typealias Input = SnippetListViewModelInput
	typealias Output = SnippetListViewModelOutput
	
	@IBOutlet private weak var tableView: UITableView!
	
	private let input: Input
	private let output: Output
	private let disposeBag = DisposeBag()
	
	init(viewModel: Input & Output = SnippetListViewModel()) {
		self.input = viewModel
		self.output = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		let viewModel = SnippetListViewModel()
		self.input = viewModel
		self.output = viewModel
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.rx.itemSelected
			.bind(to: input.itemSelected)
			.disposed(by: disposeBag)
		
		output.items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: SnnipetTableViewCell.self)) { row, element, cell in
			cell.titleLabel.text = element.title
			cell.codeLabel.text = element.body
			cell.syntaxLabel.text = element.syntax
		}.disposed(by: disposeBag)
		
		output.present.subscribe(onNext: { snippet in
			print("TODO: present a snippet on next view. \(snippet?.title ?? "")")
		}).disposed(by: disposeBag)
	}
}

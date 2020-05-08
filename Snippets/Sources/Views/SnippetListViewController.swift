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
import RxCells

class SnippetListViewController: UIViewController {
	
	typealias Input = SnippetListViewModelInput
	typealias Output = SnippetListViewModelOutput
	
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var collectionView: UICollectionView!
	private let refreshControl = UIRefreshControl()
	
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

		setupView()
		
		collectionView.rx.itemSelected
			.bind(to: input.itemSelected)
			.disposed(by: disposeBag)
		
		refreshControl.rx.controlEvent(.valueChanged)
			.bind(to: input.refresherPulled)
			.disposed(by: disposeBag)
		
		searchBar.rx.text
			.bind(to: input.searchBarText)
			.disposed(by: disposeBag)
		
		output.items
			.map { $0.enumerated() }
			.bind(to: collectionView.rx.cells(SnippetCollectionViewCell.self))
			.disposed(by: disposeBag)
		
		output.isRefreshing
			.bind(to: refreshControl.rx.isRefreshing)
			.disposed(by: disposeBag)
		
		output.present
			.compactMap { $0 }
			.subscribe(onNext: { [weak self] in
				guard let self = self else { return }
				let (index, snippet) = $0
				// TODO
			})
			.disposed(by: disposeBag)
	}
	
	private func setupView() {
		collectionView.delegate = nil
		collectionView.dataSource = nil
		collectionView.refreshControl = refreshControl
		collectionView.register(cellType: SnippetCollectionViewCell.self)
		
		let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
		layout?.itemSize = .init(width: UIScreen.main.bounds.width, height: 200)
		layout?.minimumLineSpacing = 0
		layout?.minimumLineSpacing = 0
	}
}

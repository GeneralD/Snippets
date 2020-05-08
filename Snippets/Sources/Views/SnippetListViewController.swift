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
import RxAnimated
import RxViewController

class SnippetListViewController: UIViewController {
	
	typealias Input = SnippetListViewModelInput
	typealias Output = SnippetListViewModelOutput
	
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet weak var searchBarHideConstraint: NSLayoutConstraint!
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
		
		collectionView.delegate = nil
		collectionView.dataSource = nil
		collectionView.refreshControl = refreshControl
		collectionView.register(cellType: SnippetCollectionViewCell.self)
		
		collectionView.rx.itemSelected
			.bind(to: input.itemSelected)
			.disposed(by: disposeBag)
		
		collectionView.rx.contentOffset
			.bind(to: input.contentOffset)
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
				let (_, snippet) = $0
				let viewController = SnippetDetailViewController.instantiate(model: snippet)
				self?.show(viewController, sender: nil)
			})
			.disposed(by: disposeBag)
		
		output.isSearchBarHidden
			.bind(to: searchBarHideConstraint.rx.animated.layout(duration: 0.3).isActive)
			.disposed(by: disposeBag)
		
		// This should be UICollectionViewFlowLayout, otherwise fix it on storyboard
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		
		rx.viewWillLayoutSubviews
			.compactMap { [weak self] _ in self?.view.window?.safeAreaInsets }
			.map { insets in CGSize(width: UIScreen.main.bounds.width - insets.left - insets.right, height: 200) }
			.bind(to: layout.rx.itemSize)
			.disposed(by: disposeBag)
	}
}

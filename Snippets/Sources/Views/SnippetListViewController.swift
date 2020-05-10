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
import RxDocumentPicker
import EmptyDataSet_Swift

class SnippetListViewController: UIViewController {
	
	typealias Input = SnippetListViewModelInput
	typealias Output = SnippetListViewModelOutput
	
	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet weak var pickDocumentButton: UIButton!
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
		collectionView.emptyDataSetView(output.emptyDataSetView)
		
		// Bind inputs
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
		
		pickDocumentButton.rx.tap
			.bind(to: input.pickDocumentTap)
			.disposed(by: disposeBag)
		
		self.rx.viewWillLayoutSubviews
			.compactMap { [weak self] _ in self?.view.window?.safeAreaInsets }
			.bind(to: input.viewWillLayoutSubviews)
			.disposed(by: disposeBag)
		
		// Bind outputs
		output.items
			.map { $0.enumerated() }
			.bind(to: collectionView.rx.cells(SnippetCollectionViewCell.self))
			.disposed(by: disposeBag)
		
		output.isRefreshing
			.bind(to: refreshControl.rx.isRefreshing)
			.disposed(by: disposeBag)
		
		output.isSearchBarHidden
			.bind(to: searchBarHideConstraint.rx.animated.layout(duration: 0.3).isActive)
			.disposed(by: disposeBag)
		
		// This should be UICollectionViewFlowLayout, otherwise fix it on storyboard
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		
		output.itemSize
			.bind(to: layout.rx.itemSize)
			.disposed(by: disposeBag)
		
		output.presentView
			.bind(to: self.rx.present)
			.disposed(by: disposeBag)
	}
}

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
import RxBinding
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
		
		// This should be UICollectionViewFlowLayout, otherwise fix it on storyboard
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
		
		// Bind inputs
		disposeBag ~
			collectionView.rx.itemSelected ~> input.itemSelected ~
			collectionView.rx.contentOffset ~> input.contentOffset ~
			refreshControl.rx.controlEvent(.valueChanged) ~> input.refresherPulled ~
			searchBar.rx.text ~> input.searchBarText ~
			pickDocumentButton.rx.tap ~> input.pickDocumentTap ~
			self.rx.viewWillLayoutSubviews ~> input.viewWillLayoutSubviews
		
		// Bind outputs
		disposeBag ~
			output.items ~> collectionView.rx.cells(SnippetCollectionViewCell.self) ~
			output.isRefreshing ~> refreshControl.rx.isRefreshing ~
			output.isSearchBarHidden ~> searchBarHideConstraint.rx.animated.layout(duration: 0.3).isActive ~
			output.isSearchBarHidden.map(!) ~> searchBar.rx.isFirstResponder ~
			output.itemSize ~> layout.rx.itemSize ~
			output.presentView ~> self.rx.present
	}
}

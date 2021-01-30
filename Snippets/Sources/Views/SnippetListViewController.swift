//
//  SnippetListViewController.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Instantiate
import InstantiateStandard
import RxAnimated
import RxBinding
import RxCells
import RxCocoa
import RxSwift
import RxSwiftExt
import RxViewController
import UIKit

class SnippetListViewController: UIViewController, StoryboardInstantiatable {
	private typealias Input = SnippetListViewModelInput
	private typealias Output = SnippetListViewModelOutput

	@IBOutlet private weak var collectionView: UICollectionView!
	@IBOutlet private weak var searchBar: UISearchBar!
	@IBOutlet private weak var pickDocumentButton: UIButton!
	@IBOutlet private weak var searchBarHideConstraint: NSLayoutConstraint!

	private var input: Input!
	private var output: Output!
	private let disposeBag = DisposeBag()

	func inject(_ dependency: SnippetListModel) {
		let viewModel = SnippetListViewModel(model: dependency)
		input = viewModel
		output = viewModel
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let refreshControl = UIRefreshControl()
		collectionView.refreshControl = refreshControl
		collectionView.register(cellType: SnippetCellView.self)

		// This should be UICollectionViewFlowLayout, otherwise fix it on storyboard
		// swiftlint:disable force_cast
		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

		// Bind inputs
		disposeBag ~
			collectionView.rx.itemSelected ~> input.itemSelected ~
			collectionView.rx.contentOffset ~> input.contentOffset ~
			refreshControl.rx.controlEvent(.valueChanged) ~> input.refresherPulled ~
			searchBar.rx.text ~> input.searchBarText ~
			pickDocumentButton.rx.tap ~> input.pickDocumentTap ~
			rx.viewWillLayoutSubviews ~> input.viewWillLayoutSubviews

		// Bind outputs
		disposeBag ~
			output.items ~> collectionView.rx.cells(SnippetCellView.self) ~
			output.isRefreshing ~> refreshControl.rx.isRefreshing ~
			output.isSearchBarHidden ~> searchBarHideConstraint.rx.animated.layout(duration: 0.3).isActive ~
			output.isSearchBarHidden.not() ~> searchBar.rx.isFirstResponder ~
			output.itemSize ~> layout.rx.itemSize ~
			output.presentView ~> rx.present ~
			output.emptyDataSetView ~> collectionView.rx.emptyDataSetView
	}
}

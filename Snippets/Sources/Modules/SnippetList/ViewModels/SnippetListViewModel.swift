//
//  SnippetListViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import EmptyDataSet_Swift
import Entity
import Foundation
import Fuse
import RxActivityIndicator
import RxDocumentPicker
import RxGRDB
import RxOptional
import RxPropertyChaining
import RxPropertyWrapper
import RxRelay
import RxSwift
import RxSwiftExt

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var contentOffset: AnyObserver<CGPoint> { get }
	var refresherPulled: AnyObserver<Void> { get }
	var searchBarText: AnyObserver<String?> { get }
	var pickDocumentTap: AnyObserver<Void> { get }
	var viewWillLayoutSubviews: AnyObserver<Void> { get }
}

protocol SnippetListViewModelOutput {
	var isRefreshing: Observable<Bool> { get }
	var cellModelItems: Observable<[SnippetCellViewModelInterface]> { get }
	var isSearchBarHidden: Observable<Bool> { get }
	var isSearchBarFirstResponder: Observable<Bool> { get }
	var itemSize: Observable<CGSize> { get }
	var presentView: Observable<UIViewController?> { get }
	var emptyDataSetView: Observable<(EmptyDataSetView) -> Void> { get }
}

/// @mockable
protocol SnippetListViewModelInterface: SnippetListViewModelInput, SnippetListViewModelOutput {}

final class SnippetListViewModel: SnippetListViewModelInterface {
	// MARK: Inputs

	@RxTrigger var itemSelected: AnyObserver<IndexPath>
	@RxTrigger var contentOffset: AnyObserver<CGPoint>
	@RxTrigger var refresherPulled: AnyObserver<Void>
	@RxTrigger var searchBarText: AnyObserver<String?>
	@RxTrigger var pickDocumentTap: AnyObserver<Void>
	@RxTrigger var viewWillLayoutSubviews: AnyObserver<Void>

	// MARK: Outputs

	@RxTracking var isRefreshing: Observable<Bool>
	@RxProperty(value: []) var cellModelItems: Observable<[SnippetCellViewModelInterface]>
	@RxProperty(value: true) var isSearchBarHidden: Observable<Bool>
	@RxProperty(value: false) var isSearchBarFirstResponder: Observable<Bool>
	@RxProperty(value: .square(1)) var itemSize: Observable<CGSize>
	@RxProperty(value: nil) var presentView: Observable<UIViewController?>
	@RxProperty(value: { _ in }) var emptyDataSetView: Observable<(EmptyDataSetView) -> Void>

	private let disposeBag = DisposeBag()

	init(model: SnippetListModel) {
		let emptyDataSetViewTapped = PublishRelay<Void>()
		let allISnippets = BehaviorRelay<[SQLSnippet]>(value: [])
		let snippets = BehaviorRelay<[SQLSnippet]>(value: [])

		// Bind them
		let loadUrl = ()* // to trigger immediately
			.concat($refresherPulled)
			.combineLatest(model.documentUrl)*.1
			.share()

		let picker = $pickDocumentTap
			.merge(emptyDataSetViewTapped)
			.mapTo(UIDocumentPickerViewController(forOpeningContentTypes: [.item]))
			.share()

		disposeBag.insert {
			loadUrl
				.filterNil()
				.concatMap(withLock: $isRefreshing, SQLSnippet.rx.all(url:), errorJustReturn: [])
				.bind(to: allISnippets)

			$itemSelected*.row
				.withLatestFrom(snippets) { $1[$0] }
				.withLatestFrom(model.documentUrl.unwrap(), resultSelector: SnippetDetailModel.init(snippet: documentUrl:))
				.map(SnippetDetailViewModel.init(model:))
				.map(SnippetDetailViewController.init(with:))
				.bind(to: $presentView)

			$contentOffset*.y
				.ignore(0)
				.map { $0 > 0 }
				.combineLatest(allISnippets*.isEmpty, resultSelector: !(||))
				.bind(to: $isSearchBarHidden)

			$isSearchBarHidden
				.not()
				.bind(to: $isSearchBarFirstResponder)

			$searchBarText
				.replaceNilWith("")
				.filter("")
				.combineLatest(allISnippets)*.1
				.bind(to: snippets)

			$searchBarText
				.replaceNilWith("")
				.ignore("")
				.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
				.combineLatest(allISnippets)
				.flatMapLatest { text, items in Fuse(threshold: 0.3, tokenize: true).rx.search(text: text, in: items, scoreSort: .desc) }
				.bind(to: snippets)

			snippets
				.mapMany(SnippetCellModel.init(snippet:))
				.mapMany(SnippetCellViewModel.init(model:))
				.bind(to: $cellModelItems)

			picker
				.ofType(UIViewController.self)
				.bind(to: $presentView)

			picker
				.concatMap(\.rx.didPickDocumentsAt)
				.compactMap(\.first)
				.bind(to: model.documentUrl)

			$viewWillLayoutSubviews
				.compactMap { UIApplication.shared.windows.first?.safeAreaInsets }
				.map { insets in CGSize(width: UIScreen.main.bounds.width - insets.left - insets.right, height: 200) }
				.bind(to: $itemSize)

			allISnippets*.isEmpty
				.map { noItem in
					noItem ? { view in view
						.titleLabelString(.init(string: R.string.localizable.snippetFileNotOpenedTitleLabel()))
						.detailLabelString(.init(string: R.string.localizable.snippetFileNotOpenedDetailLabel()))
						.buttonTitle(.init(string: R.string.localizable.snippetFileNotOpenedButtonLabel(), attributes: [.foregroundColor: UIColor.systemGreen]), for: .normal)
						.didTapDataButton { emptyDataSetViewTapped.accept(()) }
					} : { view in view
						.titleLabelString(.init(string: R.string.localizable.snippetNoResultTitleLabel()))
						.detailLabelString(.init(string: R.string.localizable.snippetNoResultDetailLabel()))
					}
				}
				.bind(to: $emptyDataSetView)
		}
	}
}

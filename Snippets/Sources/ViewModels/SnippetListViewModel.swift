//
//  SnippetListViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxSwiftExt
import RxOptional
import RxGRDB
import RxDocumentPicker
import EmptyDataSet_Swift
import Fuse

protocol SnippetListViewModelInput {
	var itemSelected: AnyObserver<IndexPath> { get }
	var contentOffset: AnyObserver<CGPoint> { get }
	var refresherPulled: AnyObserver<()> { get }
	var searchBarText: AnyObserver<String?> { get }
	var pickDocumentTap: AnyObserver<()> { get }
	var viewWillLayoutSubviews: AnyObserver<()> { get }
}

protocol SnippetListViewModelOutput {
	var items: Observable<[SnippetCellModel]> { get }
	var isRefreshing: Observable<Bool> { get }
	var isSearchBarHidden: Observable<Bool> { get }
	var itemSize: Observable<CGSize> { get }
	var presentView: Observable<UIViewController?> { get }
	var emptyDataSetView: Observable<(EmptyDataSetView) -> ()> { get }
}

final class SnippetListViewModel: SnippetListViewModelInput, SnippetListViewModelOutput {
	
	// MARK: Inputs
	@RxTrigger var itemSelected: AnyObserver<IndexPath>
	@RxTrigger var contentOffset: AnyObserver<CGPoint>
	@RxTrigger var refresherPulled: AnyObserver<()>
	@RxTrigger var searchBarText: AnyObserver<String?>
	@RxTrigger var pickDocumentTap: AnyObserver<()>
	@RxTrigger var viewWillLayoutSubviews: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: []) var items: Observable<[SnippetCellModel]>
	@RxProperty(value: false) var isRefreshing: Observable<Bool>
	@RxProperty(value: true) var isSearchBarHidden: Observable<Bool>
	@RxProperty(value: .square(1)) var itemSize: Observable<CGSize>
	@RxProperty(value: nil) var presentView: Observable<UIViewController?>
	@RxProperty(value: { _ in }) var emptyDataSetView: Observable<(EmptyDataSetView) -> ()>
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetListModel) {
		let emptyDataSetViewTapped = PublishRelay<()>()
		let allItems = BehaviorRelay<[SQLSnippet]>(value: [])
		
		// Bind them
		let loadUrl = Observable.just(()) // to trigger immediately
			.concat($refresherPulled)
			.combineLatest(model.documentUrl)
			.map(\.1)
			.share()
		
		let picker = $pickDocumentTap
			.merge(emptyDataSetViewTapped.asObservable())
			.mapTo(UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open))
			.share()
		
		disposeBag.insert {
			loadUrl
				.filterNil()
				.concatMap(SQLSnippet.rx.all(url: ), errorJustReturn: [])
				.bind(to: allItems)
			
			$itemSelected
				.map(\.row)
				.withLatestFrom($items) { $1[$0] }
				.map(\.snippet)
				.withLatestFrom(model.documentUrl.unwrap(), resultSelector: SnippetDetailModel.init(snippet: documentUrl: ))
				.map(SnippetDetailViewController.init(with: ))
				.bind(to: $presentView)
			
			$contentOffset
				.map(\.y)
				.ignore(0)
				.map { $0 > 0 }
				.combineLatest(allItems.map(\.isEmpty), resultSelector: !(||))
				.bind(to: $isSearchBarHidden)
			
			$searchBarText
				.replaceNilWith(.empty)
				.filter(.empty)
				.combineLatest(allItems)
				.map(\.1)
				.mapMany(SnippetCellModel.init(snippet: ))
				.bind(to: $items)
			
			$searchBarText
				.replaceNilWith(.empty)
				.ignore(.empty)
				.debounce(.milliseconds(300), scheduler: MainScheduler.instance)
				.combineLatest(allItems)
				.flatMapLatest { Fuse(threshold: 0.3, tokenize: true).rx.search(text: $0.0, in: $0.1, scoreSort: .desc) }
				.mapMany(SnippetCellModel.init(snippet: ))
				.bind(to: $items)
			
			// If failed to pick an URL, hide loading indicator
			loadUrl
				.filter(.none)
				.mapTo(false)
				.bind(to: $isRefreshing)
			
			// If items are loaded, hide loading indicator
			$items
				.mapTo(false)
				.bind(to: $isRefreshing)
			
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
			
			allItems
				.map(\.isEmpty)
				.map { noItem in noItem ? { view in view
					.titleLabelString(.init(string: R.string.localizable.snippetFileNotOpenedTitleLabel()))
					.detailLabelString(.init(string: R.string.localizable.snippetFileNotOpenedDetailLabel()))
					.buttonTitle(.init(string: R.string.localizable.snippetFileNotOpenedButtonLabel(), attributes: [.foregroundColor: UIColor.systemGreen]), for: .normal)
					.didTapDataButton { emptyDataSetViewTapped() }
				} : { view in view
					.titleLabelString(.init(string: R.string.localizable.snippetNoResultTitleLabel()))
					.detailLabelString(.init(string: R.string.localizable.snippetNoResultDetailLabel()))
				}}
				.bind(to: $emptyDataSetView)
		}
	}
}

//
//  SnippetCellViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/09/04.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxOptional

protocol SnippetCellViewModelInput {
	var copyButtonTap: AnyObserver<()> { get }
}

protocol SnippetCellViewModelOutput {
	var titleText: Observable<String?> { get }
	var codeText: Observable<String?> { get }
	var languageText: Observable<String?> { get }
	var languageHidden: Observable<Bool> { get }
	var languageBackgroundColor: Observable<UIColor?> { get }
	var contentViewBackgroundColor: Observable<UIColor?> { get }
}

final class SnippetCellViewModel: SnippetCellViewModelInput, SnippetCellViewModelOutput {
	
	// MARK: Inputs
	@RxTrigger var copyButtonTap: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: nil) var titleText: Observable<String?>
	@RxProperty(value: nil) var codeText: Observable<String?>
	@RxProperty(value: nil) var languageText: Observable<String?>
	@RxProperty(value: false) var languageHidden: Observable<Bool>
	@RxProperty(value: nil) var languageBackgroundColor: Observable<UIColor?>
	@RxProperty(value: nil) var contentViewBackgroundColor: Observable<UIColor?>
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetCellModel) {
		let snippet = Observable.just(model.snippet)
		
		let color = snippet
			.map(\.syntax)
			.replaceNilWith(.empty) // empty can make a color?
			.compactMap(UIColor.themeColor(for: ))
			.map(\.comfortable)
			.share()
		
		disposeBag.insert {
			$copyButtonTap
				.withLatestFrom(snippet)
				.map(\.body)
				.bind(to: UIPasteboard.general.rx.string)
			
			snippet
				.map(\.title)
				.bind(to: $titleText)
			
			snippet
				.map(\.body)
				.bind(to: $codeText)
			
			snippet
				.map(\.syntax)
				.bind(to: $languageText)
			
			snippet
				.map(\.syntax?.isEmpty)
				.replaceNilWith(true)
				.bind(to: $languageHidden)
			
			color
				.bind(to: $languageBackgroundColor)
			
			color
				.map { $0.adjustedAlpha(amount: -0.7) }
				.bind(to: $contentViewBackgroundColor)
		}
	}
}

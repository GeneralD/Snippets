//
//  SnippetDetailViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import LanguageThemeColor
import RxBinding
import RxOptional
import RxPropertyChaining
import RxPropertyWrapper
import RxRelay
import RxSwift

protocol SnippetDetailViewModelInput {
	var copyButtonTap: AnyObserver<Void> { get }
}

protocol SnippetDetailViewModelOutput {
	var title: Observable<String?> { get }
	var code: Observable<String?> { get }
	var tags: Observable<[String]> { get }
	var tagColors: Observable<[UIColor]> { get }
	var viewColor: Observable<UIColor?> { get }
}

final class SnippetDetailViewModel: SnippetDetailViewModelInput, SnippetDetailViewModelOutput {
	// MARK: Inputs

	@RxTrigger var copyButtonTap: AnyObserver<Void>

	// MARK: Outputs

	@RxProperty(value: nil) var title: Observable<String?>
	@RxProperty(value: nil) var code: Observable<String?>
	@RxProperty(value: []) var tags: Observable<[String]>
	@RxProperty(value: []) var tagColors: Observable<[UIColor]>
	@RxProperty(value: nil) var viewColor: Observable<UIColor?>

	private let disposeBag = DisposeBag()

	init(model: SnippetDetailModel) {
		let snippet = model.snippet*

		disposeBag.insert {
			snippet*.title ~> $title

			snippet*.body ~> $code

			snippet*.syntax
				.replaceNilWith("")
				.compactMap(UIColor.themeColor(for:))*.alphaAdjusted
				~> $viewColor

			snippet
				.flatMap { $0.rx.tags(url: model.documentUrl) }
				~> $tags

			$copyButtonTap
				.withLatestFrom($code)
				~> UIPasteboard.general.rx.string

			$tags
				.delay(.nanoseconds(0), scheduler: MainScheduler.instance) // wait a frame
				.mapMany(UIColor.themeColor(for:))
				~> $tagColors
		}
	}
}

//
//  SnippetCellViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/09/04.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Entity
import Foundation
import LanguageThemeColor
import RxBinding
import RxOptional
import RxPropertyChaining
import RxPropertyWrapper
import RxRelay
import RxSwift
import UIKit

protocol SnippetCellViewModelInput {
	var copyButtonTap: AnyObserver<Void> { get }
}

protocol SnippetCellViewModelOutput {
	var titleText: Observable<String?> { get }
	var codeText: Observable<String?> { get }
	var languageText: Observable<String?> { get }
	var languageHidden: Observable<Bool> { get }
	var languageBackgroundColor: Observable<UIColor?> { get }
	var contentViewBackgroundColor: Observable<UIColor?> { get }
}

/// @mockable
protocol SnippetCellViewModelInterface: SnippetCellViewModelInput, SnippetCellViewModelOutput {}

final class SnippetCellViewModel: SnippetCellViewModelInterface {
	// MARK: Inputs

	@RxTrigger var copyButtonTap: AnyObserver<Void>

	// MARK: Outputs

	@RxProperty(value: nil) var titleText: Observable<String?>
	@RxProperty(value: nil) var codeText: Observable<String?>
	@RxProperty(value: nil) var languageText: Observable<String?>
	@RxProperty(value: false) var languageHidden: Observable<Bool>
	@RxProperty(value: nil) var languageBackgroundColor: Observable<UIColor?>
	@RxProperty(value: nil) var contentViewBackgroundColor: Observable<UIColor?>

	private let disposeBag = DisposeBag()

	init(model: SnippetCellModel) {
		let snippet = model.snippet*

		let color = snippet*.syntax
			.replaceNilWith("")
			.compactMap(UIColor.themeColor(for:))*.brightnessAdjusted
			.share()

		disposeBag.insert {
			$copyButtonTap
				.withLatestFrom(snippet)*.body
				~> UIPasteboard.general.rx.string

			snippet*.title ~> $titleText

			snippet*.body ~> $codeText

			snippet*.syntax ~> $languageText

			snippet
				.map(\.syntax?.isEmpty)
				.replaceNilWith(true)
				~> $languageHidden

			color ~> $languageBackgroundColor

			color*.alphaAdjusted ~> $contentViewBackgroundColor
		}
	}
}

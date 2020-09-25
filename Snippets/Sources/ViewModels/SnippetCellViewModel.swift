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
	let copyButtonTap: AnyObserver<()>
	
	// MARK: Outputs
	let titleText: Observable<String?>
	let codeText: Observable<String?>
	let languageText: Observable<String?>
	let languageHidden: Observable<Bool>
	let languageBackgroundColor: Observable<UIColor?>
	let contentViewBackgroundColor: Observable<UIColor?>
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetCellModel) {
		let _copyButtonTap = PublishRelay<()>()
		self.copyButtonTap = _copyButtonTap.asObserver()
		
		let _titleText = BehaviorRelay<String?>(value: nil)
		self.titleText = _titleText.asObservable()
		
		let _codeText = BehaviorRelay<String?>(value: nil)
		self.codeText = _codeText.asObservable()
		
		let _languageText = BehaviorRelay<String?>(value: nil)
		self.languageText = _languageText.asObservable()
		
		let _languageHidden = BehaviorRelay<Bool>(value: false)
		self.languageHidden = _languageHidden.asObservable()
		
		let _languageBackgroundColor = BehaviorRelay<UIColor?>(value: nil)
		self.languageBackgroundColor = _languageBackgroundColor.asObservable()
		
		let _contentViewBackgroundColor = BehaviorRelay<UIColor?>(value: nil)
		self.contentViewBackgroundColor = _contentViewBackgroundColor.asObservable()
		
		let snippet = Observable.just(model.snippet)
		
		_copyButtonTap
			.withLatestFrom(snippet)
			.map(\.body)
			.bind(to: UIPasteboard.general.rx.string)
			.disposed(by: disposeBag)
		
		snippet
			.map(\.title)
			.bind(to: _titleText)
			.disposed(by: disposeBag)
		
		snippet
			.map(\.body)
			.bind(to: _codeText)
			.disposed(by: disposeBag)
		
		snippet
			.map(\.syntax)
			.bind(to: _languageText)
			.disposed(by: disposeBag)
		
		snippet
			.map(\.syntax?.isEmpty)
			.replaceNilWith(true)
			.bind(to: _languageHidden)
			.disposed(by: disposeBag)
		
		let color = snippet
			.map(\.syntax)
			.replaceNilWith("") // empty can make a color?
			.compactMap(UIColor.themeColor(for: ))
			.map(\.comfortable)
			.share()
		
		color
			.bind(to: _languageBackgroundColor)
			.disposed(by: disposeBag)
		
		color
			.map { $0.adjustedAlpha(amount: -0.7) }
			.bind(to: _contentViewBackgroundColor)
			.disposed(by: disposeBag)
	}
}

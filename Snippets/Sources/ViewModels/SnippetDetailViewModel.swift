//
//  SnippetDetailViewModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxSwiftExt
import RxOptional

protocol SnippetDetailViewModelInput {
	var copyButtonTap: AnyObserver<()> { get }
}

protocol SnippetDetailViewModelOutput {
	var title: Observable<String?> { get }
	var code: Observable<String?> { get }
	var tags: Observable<[String]> { get }
}

final class SnippetDetailViewModel: SnippetDetailViewModelInput, SnippetDetailViewModelOutput {
	
	// MARK: Inputs
	let copyButtonTap: AnyObserver<()>
	
	// MARK: Outputs
	let title: Observable<String?>
	let code: Observable<String?>
	let tags: Observable<[String]>
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetDetailModel) {
		// Inputs
		let _copyButtonTap = PublishRelay<()>()
		self.copyButtonTap = _copyButtonTap.asObserver()
		
		// Outputs
		let _title = BehaviorRelay<String?>(value: nil)
		title = _title.asObservable()
		
		let _code = BehaviorRelay<String?>(value: nil)
		code = _code.asObservable()
		
		let _tags = BehaviorRelay<[String]>(value: [])
		tags = _tags.asObservable()
		
		let _snippet = Observable.just(model.snippet)
		
		// Bind them
		_snippet
			.mapAt(\.title)
			.bind(to: _title)
			.disposed(by: disposeBag)
		
		_snippet
			.mapAt(\.body)
			.bind(to: _code)
			.disposed(by: disposeBag)
		
		_snippet
			.map { $0.rx.tags(url: model.documentUrl) }
			.flatten()
			.bind(to: _tags)
			.disposed(by: disposeBag)
		
		_copyButtonTap
			.withLatestFrom(_code)
			.bind(to: UIPasteboard.general.rx.string)
			.disposed(by: disposeBag)
	}
}

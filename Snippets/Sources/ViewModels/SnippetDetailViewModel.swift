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
import RxOptional
import SwiftyUserDefaults

protocol SnippetDetailViewModelInput {
	var model: AnyObserver<SQLSnippet?> { get }
}

protocol SnippetDetailViewModelOutput {
	var title: Observable<String?> { get }
	var code: Observable<String?> { get }
	var tags: Observable<[String]> { get }
}

final class SnippetDetailViewModel: SnippetDetailViewModelInput, SnippetDetailViewModelOutput {
	
	// MARK: Inputs
	var model: AnyObserver<SQLSnippet?>
	
	// MARK: Outputs
	let title: Observable<String?>
	let code: Observable<String?>
	let tags: Observable<[String]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		// Inputs
		let _model = PublishRelay<SQLSnippet?>()
		model = _model.asObserver()
		
		// Outputs
		let _title = BehaviorRelay<String?>(value: nil)
		title = _title.asObservable()
		
		let _code = BehaviorRelay<String?>(value: nil)
		code = _code.asObservable()
		
		let _tags = BehaviorRelay<[String]>(value: [])
		tags = _tags.asObservable()
		
		// Bind them
		_model
			.map { $0?.title }
			.bind(to: _title)
			.disposed(by: disposeBag)
		
		_model
			.map { $0?.body }
			.bind(to: _code)
			.disposed(by: disposeBag)
		
		if let fileUrl = Defaults.documentUrl {
			_model
				.filterNil()
				.flatMap { snippet in snippet.rx.tags(url: fileUrl) }
				.bind(to: _tags)
				.disposed(by: disposeBag)
		} else {
			print("There must be fileUrl if you can come this view!")
		}
	}
}

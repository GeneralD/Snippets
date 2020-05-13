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
	var copyButtonTap: AnyObserver<()> { get }
}

protocol SnippetDetailViewModelOutput {
	var title: Observable<String?> { get }
	var code: Observable<String?> { get }
	var tags: Observable<[String]> { get }
}

final class SnippetDetailViewModel: SnippetDetailViewModelInput, SnippetDetailViewModelOutput {
	
	// MARK: Inputs
	let model: AnyObserver<SQLSnippet?>
	let copyButtonTap: AnyObserver<()>
	
	// MARK: Outputs
	let title: Observable<String?>
	let code: Observable<String?>
	let tags: Observable<[String]>
	
	private let disposeBag = DisposeBag()
	
	init() {
		// Inputs
		let _model = PublishRelay<SQLSnippet?>()
		model = _model.asObserver()
		
		let _copyButtonTap = PublishRelay<()>()
		self.copyButtonTap = _copyButtonTap.asObserver()
		
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
		
		_model
			.compactMap { $0?.rx.tags(url: ) }
			.compactMap(Defaults.documentUrl.map)
			.flatten()
			.bind(to: _tags)
			.disposed(by: disposeBag)
		
		_copyButtonTap
			.subscribe(onNext: { UIPasteboard.general.string = _code.value })
			.disposed(by: disposeBag)
	}
}

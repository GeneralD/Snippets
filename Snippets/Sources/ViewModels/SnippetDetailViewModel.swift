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
import SwiftyUserDefaults

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
	
	init(model: SQLSnippet) {
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
		
		let _model = PublishSubject.just(model)
		
		// Bind them
		_model
			.mapAt(\.title)
			.bind(to: _title)
			.disposed(by: disposeBag)
		
		_model
			.mapAt(\.body)
			.bind(to: _code)
			.disposed(by: disposeBag)
		
		_model
			.map { $0.rx.tags(url: ) }
			.compactMap(Defaults.documentUrl.map)
			.flatten()
			.bind(to: _tags)
			.disposed(by: disposeBag)
		
		_copyButtonTap
			.mapTo(_code.value)
			.bind(to: UIPasteboard.general.rx.string)
			.disposed(by: disposeBag)
	}
}

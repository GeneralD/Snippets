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
	@RxTrigger var copyButtonTap: AnyObserver<()>
	
	// MARK: Outputs
	@RxProperty(value: nil) var title: Observable<String?>
	@RxProperty(value: nil) var code: Observable<String?>
	@RxProperty(value: []) var tags: Observable<[String]>
	
	private let disposeBag = DisposeBag()
	
	init(model: SnippetDetailModel) {		
		let _snippet = Observable.just(model.snippet)
		
		disposeBag.insert {
			_snippet
				.map(\.title)
				.bind(to: $title)
			
			_snippet
				.map(\.body)
				.bind(to: $code)
			
			_snippet
				.flatMap { $0.rx.tags(url: model.documentUrl) }
				.bind(to: $tags)
			
			$copyButtonTap
				.withLatestFrom($code)
				.bind(to: UIPasteboard.general.rx.string)
		}
	}
}

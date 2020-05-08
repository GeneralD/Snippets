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
	var selected: AnyObserver<Int> { get }
}

protocol SnippetDetailViewModelOutput {
	var title: Observable<String?> { get }
}

final class SnippetDetailViewModel: SnippetDetailViewModelInput, SnippetDetailViewModelOutput {
	
	// MARK: Inputs
	let selected: AnyObserver<Int>
	
	// MARK: Outputs
	let title: Observable<String?>
	
	private let disposeBag = DisposeBag()
	
	init() {
		let selectedRelay = PublishRelay<Int>()
		selected = selectedRelay.asObserver()
		let titleRelay = BehaviorRelay<String?>(value: nil)
		title = titleRelay.asObservable()
		
		// Do something here...
	}
}

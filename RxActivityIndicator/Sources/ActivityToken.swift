//
//  ActivityToken.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/04/23.
//

import RxSwift

struct ActivityToken<E> {
	private let source: Observable<E>
	private let cancelable: Cancelable

	init(source: Observable<E>, disposeAction: @escaping () -> Void) {
		self.source = source
		cancelable = Disposables.create(with: disposeAction)
	}
}

extension ActivityToken: Disposable {
	func dispose() {
		cancelable.dispose()
	}
}

extension ActivityToken: ObservableConvertibleType {
	typealias Element = E

	func asObservable() -> Observable<Element> {
		source
	}
}

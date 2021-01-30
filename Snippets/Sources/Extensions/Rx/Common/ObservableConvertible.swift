//
//  ObservableConvertible.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/09.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift

public extension Optional {
	func asObservable() -> Observable<Wrapped> {
		switch self {
		case let .some(wrapped):
			return .just(wrapped)
		case .none:
			return .empty()
		}
	}
}

public extension Result {
	func asObservable() -> Observable<Success> {
		switch self {
		case let .success(success):
			return .just(success)
		case let .failure(error):
			return .error(error)
		}
	}
}

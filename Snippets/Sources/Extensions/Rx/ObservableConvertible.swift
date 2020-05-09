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
		case .some(let wrapped):
			return .just(wrapped)
		case .none:
			return .empty()
		}
	}
}

public extension Result {
	func asObservable() -> Observable<Success> {
		switch self {
		case .success(let success):
			return .just(success)
		case .failure(let error):
			return .error(error)
		}
	}
}

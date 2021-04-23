//
//  ObservableConvertibleType+ActivityIndicator.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/04/23.
//

import RxSwift

public extension ObservableConvertibleType {
	func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
		activityIndicator.trackActivityOfObservable(self)
	}

	func flatMap<O: ObservableConvertibleType>(withLock: ActivityIndicator, _ selector: @escaping (Element) throws -> O) -> Observable<O.Element> {
		asObservable()
			.withLatestFrom(withLock) { input, loading in (input, loading) }
			.filter { _, loading in !loading }
			.flatMap { input, _ in try selector(input).trackActivity(withLock) }
	}

	func flatMap<O: ObservableConvertibleType>(withLock: ActivityIndicator, _ selector: @escaping (Element) throws -> O, errorJustReturn element: O.Element) -> Observable<O.Element> {
		asObservable()
			.withLatestFrom(withLock) { input, loading in (input, loading) }
			.filter { _, loading in !loading }
			.flatMap { input, _ in
				try selector(input)
					.asObservable()
					.catchAndReturn(element)
					.trackActivity(withLock)
			}
	}

	func concatMap<O: ObservableConvertibleType>(withLock: ActivityIndicator, _ selector: @escaping (Element) throws -> O) -> Observable<O.Element> {
		asObservable()
			.withLatestFrom(withLock) { input, loading in (input, loading) }
			.filter { _, loading in !loading }
			.concatMap { input, _ in try selector(input).trackActivity(withLock) }
	}

	func concatMap<O: ObservableConvertibleType>(withLock: ActivityIndicator, _ selector: @escaping (Element) throws -> O, errorJustReturn element: O.Element) -> Observable<O.Element> {
		asObservable()
			.withLatestFrom(withLock) { input, loading in (input, loading) }
			.filter { _, loading in !loading }
			.concatMap { input, _ in
				try selector(input)
					.asObservable()
					.catchAndReturn(element)
					.trackActivity(withLock)
			}
	}
}

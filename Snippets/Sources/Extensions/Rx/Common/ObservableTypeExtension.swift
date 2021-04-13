//
//  ObservableTypeExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift

public extension ObservableConvertibleType {
	func merge<O: ObservableConvertibleType>(_ sources: O...) -> Observable<Element> where O.Element == Element {
		Observable.create { observer -> Disposable in
			Disposables.create(asObservable().bind(to: observer), Disposables.create(sources.map { $0.asObservable().bind(to: observer) }))
		}
	}

	func combineLatest<Another: ObservableConvertibleType, ResultElement>(_ source1: Another, resultSelector: @escaping (Element, Another.Element) throws -> ResultElement) -> Observable<ResultElement> {
		.combineLatest(asObservable(), source1.asObservable(), resultSelector: resultSelector)
	}

	func combineLatest<Another: ObservableType>(_ source1: Another) -> Observable<(Element, Another.Element)> {
		.combineLatest(asObservable(), source1.asObservable()) { ($0, $1) }
	}
}

// MARK: Map

public extension ObservableConvertibleType {
	func mapTo<Result>(defer value: @escaping @autoclosure () -> Result) -> Observable<Result> {
		asObservable().map { _ in value() }
	}
}

// MARK: FlatMap

public extension ObservableConvertibleType {
	func flatMap<Source>(_ selector: @escaping (Element) throws -> Source, errorJustReturn element: Source.Element) -> Observable<Source.Element> where Source: ObservableConvertibleType {
		asObservable().flatMap { try selector($0).asObservable().catchAndReturn(element) }
	}

	func flatMapTo<Result>(_ observable: Observable<Result>) -> Observable<Result> {
		asObservable().flatMap { _ in observable }
	}

	func flatMapTo<Result>(defer observable: @escaping @autoclosure () -> Observable<Result>) -> Observable<Result> {
		asObservable().flatMap { _ in observable() }
	}
}

public extension ObservableConvertibleType where Element: ObservableConvertibleType {
	func flatten() -> Observable<Element.Element> {
		asObservable().flatMap { $0 }
	}
}

// MARK: ConcatMap

public extension ObservableConvertibleType {
	func concatMap<Source>(_ selector: @escaping (Element) throws -> Source, errorJustReturn element: Source.Element) -> Observable<Source.Element> where Source: ObservableConvertibleType {
		asObservable().concatMap { try selector($0).asObservable().catchAndReturn(element) }
	}
}

// MARK: Filter

public extension ObservableType where Element: Equatable {
	func filter(_ element: Element) -> Observable<Element> {
		filter { $0 == element }
	}
}

public extension ObservableConvertibleType {
	func filterWithLatestFrom<Source: ObservableConvertibleType>(_ second: Source, resultSelector: @escaping (Element, Source.Element) throws -> Bool) -> Observable<Element> {
		asObservable()
			.withLatestFrom(second, resultSelector: resultSelector)
			.filter(true)
			.withLatestFrom(self)
	}
}

// MARK: FilterMany

public extension ObservableConvertibleType where Self.Element: Collection {
	func filterMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
		asObservable().map { try $0.filter(predicate) }
	}

	func ignoreMany(_ predicate: @escaping (Element.Element) throws -> Bool) -> Observable<[Element.Element]> {
		asObservable().map { try $0.filter { i in try !predicate(i) } }
	}
}

// MARK: MapMany

public extension ObservableConvertibleType where Element: Collection {
	func compactMapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result?) -> Observable<[Result]> {
		asObservable().map { try $0.compactMap(transform) }
	}
}

// MARK: DoMany

public extension ObservableConvertibleType where Element: Collection {
	func doMany(onNext: ((Element.Element) throws -> Void)? = nil, afterNext: ((Element.Element) throws -> Void)? = nil) -> Observable<Element> {
		asObservable().do(onNext: { _ = try onNext.map($0.forEach) }, afterNext: { _ = try afterNext.map($0.forEach) })
	}
}

// MARK: Bool

public extension ObservableConvertibleType where Element == Bool {
	func map<T>(onTrue: @autoclosure @escaping () -> T, onFalse: @autoclosure @escaping () -> T) -> Observable<T> {
		asObservable().map { $0 ? onTrue() : onFalse() }
	}

	func flatMap<Result>(onTrue: @autoclosure @escaping () -> Observable<Result>, onFalse: @autoclosure @escaping () -> Observable<Result>) -> Observable<Result> {
		asObservable().flatMap { $0 ? onTrue() : onFalse() }
	}
}

// MARK: Debug

public extension ObservableConvertibleType {
	func printConsole(
		onNext: ((Element) throws -> String)? = nil, afterNext: ((Element) throws -> String)? = nil,
		onError: ((Error) throws -> String)? = nil, afterError: ((Error) throws -> String)? = nil,
		onCompleted: (() throws -> String)? = nil, afterCompleted: (() throws -> String)? = nil,
		onSubscribe: (() -> String)? = nil, onSubscribed: (() -> String)? = nil,
		onDispose: (() -> String)? = nil
	) -> Observable<Element> {
		asObservable().do(
			onNext: { elem in try onNext.map { f in try print(f(elem)) } },
			afterNext: { elem in try afterNext.map { f in try print(f(elem)) } },
			onError: { error in try onError.map { f in try print(f(error)) } },
			afterError: { error in try afterError.map { f in try print(f(error)) } },
			onCompleted: { try onCompleted.map { f in try print(f()) } },
			afterCompleted: { try afterCompleted.map { f in try print(f()) } },
			onSubscribe: { onSubscribe.map { f in print(f()) } },
			onSubscribed: { onSubscribed.map { f in print(f()) } },
			onDispose: { onDispose.map { f in print(f()) } }
		)
	}
}

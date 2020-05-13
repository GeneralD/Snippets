//
//  ObservableTypeExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift

public extension ObservableType {
	
	func merge(_ sources: Observable<Element>...) -> Observable<Element> {
		.merge([self.asObservable()] + sources)
	}
	
	func combineLatest<Another: ObservableType, ResultElement>(_ source1: Another, resultSelector: @escaping (Element, Another.Element) throws -> ResultElement) -> Observable<ResultElement> {
		.combineLatest(self, source1, resultSelector: resultSelector)
	}
}

public extension ObservableType where Element: ObservableConvertibleType {

	func flatten() -> Observable<Element.Element> {
		flatMap { a in a }
	}
}

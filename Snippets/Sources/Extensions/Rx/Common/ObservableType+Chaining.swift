//
//  ObservableType+Chaining.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/01/09.
//  Copyright © 2021 ZYXW. All rights reserved.
//

import RxSwift

postfix operator *

// swiftlint:disable static_operator
public postfix func * <O: ObservableType>(_ o: O) -> ObservableTypeMemberLookupReference<O> {
	.init(source: o)
}

// swiftlint:disable static_operator
public postfix func * <O: ObservableType>(_ o: O) -> ObservableTypeMemberLookupReference<Observable<O.Element.Element>> where O.Element: ObservableConvertibleType {
	.init(source: o.flatMap { $0 })
}

@dynamicMemberLookup
public struct ObservableTypeMemberLookupReference<O: ObservableType> {
	fileprivate let source: O

	subscript<Property>(dynamicMember keyPath: KeyPath<O.Element, Property>) -> Observable<Property> {
		source.map { t in t[keyPath: keyPath] }
	}
}

//
//  AnyObserverConvertible.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxRelay
import RxSwift

public protocol AnyObserverConvertible {
	associatedtype Element
	func accept(_: Element)
}

extension BehaviorRelay: AnyObserverConvertible {}

extension PublishRelay: AnyObserverConvertible {}

extension ReplayRelay: AnyObserverConvertible {}

public extension AnyObserverConvertible {
	func asObserver() -> AnyObserver<Element> {
		.init { event in
			guard case let .next(element) = event else { return }
			accept(element)
		}
	}
}

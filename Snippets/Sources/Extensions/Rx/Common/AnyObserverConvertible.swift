//
//  AnyObserverConvertible.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift
import RxRelay

public protocol AnyObserverConvertible {
	associatedtype Element
	func accept(_: Element)
}
extension BehaviorRelay: AnyObserverConvertible {}

extension PublishRelay: AnyObserverConvertible {}

public extension AnyObserverConvertible {
	
	func asObserver() -> AnyObserver<Element> {
		.init { event in
			guard case .next(let element) = event else { return }
			accept(element)
		}
	}
	
	func callAsFunction(_ element: Element) {
		accept(element)
	}
}

public extension AnyObserverConvertible where Element == () {
	
	func callAsFunction() {
		accept(())
	}
}

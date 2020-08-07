//
//  AnyObserverConvertible.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift
import RxRelay

protocol AnyObserverConvertible {
	associatedtype Element
	func accept(_: Element)
}
extension BehaviorRelay: AnyObserverConvertible {}

extension PublishRelay: AnyObserverConvertible {}

extension AnyObserverConvertible {
	public func asObserver() -> AnyObserver<Element> {
		.init { event in
			guard case .next(let element) = event else { return }
			self.accept(element)
		}
	}
}

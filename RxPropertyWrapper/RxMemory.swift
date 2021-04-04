//
//  RxMemory.swift
//  RxPropertyWrapper
//
//  Created by Yumenosuke Koukata on 2021/04/04.
//

import RxRelay
import RxSwift

@propertyWrapper
public struct RxMemory<Value> {
	private let relay: ReplayRelay<Value>
	private let property: Observable<Value>

	public init(buffer: Int? = nil) {
		relay =  buffer.map(ReplayRelay.create(bufferSize: )) ?? .createUnbound()
		property = relay.asObservable()
	}

	public var wrappedValue: Observable<Value> {
		property
	}

	public var projectedValue: ReplayRelay<Value> {
		relay
	}
}

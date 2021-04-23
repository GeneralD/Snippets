//
//  RxTracking.swift
//  RxActivityIndicator
//
//  Created by Yumenosuke Koukata on 2021/04/23.
//

import RxSwift

@propertyWrapper
public struct RxTracking {
	private let activityIndicator = ActivityIndicator()

	public init() {}

	public var wrappedValue: Observable<Bool> {
		activityIndicator.asObservable()
	}

	public var projectedValue: ActivityIndicator {
		activityIndicator
	}
}

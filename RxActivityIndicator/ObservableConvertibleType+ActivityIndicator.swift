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
}

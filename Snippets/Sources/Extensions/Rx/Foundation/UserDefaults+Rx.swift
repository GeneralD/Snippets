//
//  UserDefaults+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/09.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public extension Reactive where Base: UserDefaults {
	func `default`<E: Equatable>(type _: E.Type) -> ReactiveUserDefaultsLoopup<E> {
		.init(base)
	}

	var integer: ReactiveUserDefaultsLoopup<Int> {
		.init(base)
	}

	var float: ReactiveUserDefaultsLoopup<Float> {
		.init(base)
	}

	var double: ReactiveUserDefaultsLoopup<Double> {
		.init(base)
	}

	var bool: ReactiveUserDefaultsLoopup<Bool> {
		.init(base)
	}

	var string: ReactiveUserDefaultsLoopup<String> {
		.init(base)
	}

	var data: ReactiveUserDefaultsLoopup<Data> {
		.init(base)
	}

	var object: ReactiveUserDefaultsLoopup<AnyObject> {
		.init(base)
	}

	var url: ReactiveUserDefaultsLoopup<URL> {
		.init(base)
	}
}

@dynamicMemberLookup
public struct ReactiveUserDefaultsLoopup<T> {
	private let defaults: UserDefaults

	fileprivate init(_ defaults: UserDefaults) {
		self.defaults = defaults
	}
}

public extension ReactiveUserDefaultsLoopup where T: AnyObject {
	subscript(dynamicMember key: String) -> ControlProperty<T?> {
		let source = Observable.deferred { [weak defaults] () -> Observable<T?> in
			let center = NotificationCenter.default
			let initial = defaults?.object(forKey: key) as? T
			let changes = center.rx.notification(UserDefaults.didChangeNotification)
				.map { _ in defaults?.object(forKey: key) as? T }

			return Observable.just(initial)
				.concat(changes)
				.distinctUntilChanged(===)
		}

		let binder = Binder(defaults) { (defaults, value: T?) in
			defaults.set(value, forKey: key)
		}

		return .init(values: source, valueSink: binder)
	}
}

public extension ReactiveUserDefaultsLoopup where T: Equatable {
	subscript(dynamicMember key: String) -> ControlProperty<T?> {
		let source = Observable.deferred { [weak defaults] () -> Observable<T?> in
			let center = NotificationCenter.default
			let initial = defaults?.object(forKey: key) as? T
			let changes = center.rx.notification(UserDefaults.didChangeNotification)
				.map { _ in defaults?.object(forKey: key) as? T }

			return Observable.just(initial)
				.concat(changes)
				.distinctUntilChanged()
		}

		let binder = Binder(defaults) { (defaults, value: T?) in
			defaults.set(value, forKey: key)
		}

		return .init(values: source, valueSink: binder)
	}
}

public extension ReactiveUserDefaultsLoopup where T == URL {
	subscript(dynamicMember key: String) -> ControlProperty<URL?> {
		let source = Observable.deferred { [weak defaults] () -> Observable<URL?> in
			let center = NotificationCenter.default
			let initial = defaults?.url(forKey: key)
			let changes = center.rx.notification(UserDefaults.didChangeNotification)
				.map { _ in defaults?.url(forKey: key) }

			return Observable.just(initial)
				.concat(changes)
				.distinctUntilChanged()
		}

		let binder = Binder(defaults) { (defaults, value: URL?) in
			defaults.set(value, forKey: key)
		}

		return .init(values: source, valueSink: binder)
	}
}

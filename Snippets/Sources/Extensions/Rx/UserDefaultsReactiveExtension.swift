//
//  UserDefaultsReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/09.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UserDefaults {
	
	func `default`<E: Equatable>(type _: E.Type) -> ReactiveUserDefaultsLoopup<E> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var integer: ReactiveUserDefaultsLoopup<Int> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var float: ReactiveUserDefaultsLoopup<Float> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var double: ReactiveUserDefaultsLoopup<Double> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var bool: ReactiveUserDefaultsLoopup<Bool> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var string: ReactiveUserDefaultsLoopup<String> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var data: ReactiveUserDefaultsLoopup<Data> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var object: ReactiveUserDefaultsLoopup<AnyObject> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var url: ReactiveUserDefaultsLoopup<URL> {
		ReactiveUserDefaultsLoopup(base)
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
		
		return ControlProperty(values: source, valueSink: binder)
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
		
		return ControlProperty(values: source, valueSink: binder)
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
		
		return ControlProperty(values: source, valueSink: binder)
	}
}

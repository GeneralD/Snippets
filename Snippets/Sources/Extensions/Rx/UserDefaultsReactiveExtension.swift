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
import Runes
import Curry

public extension Reactive where Base: UserDefaults {
	
	func `default`<E: Equatable>(type: E) -> ReactiveUserDefaultsLoopup<E> {
		ReactiveUserDefaultsLoopup(base)
	}
	
	var url: ReactiveUserDefaultsLoopup<URL> {
		ReactiveUserDefaultsLoopup(base)
	}
}

@dynamicMemberLookup
public struct ReactiveUserDefaultsLoopup<T: Equatable> {
	
	private let defaults: UserDefaults
	
	fileprivate init(_ defaults: UserDefaults) {
		self.defaults = defaults
	}
}

public extension ReactiveUserDefaultsLoopup {
	
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

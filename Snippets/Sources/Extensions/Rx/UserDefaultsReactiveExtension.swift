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
	
	func `default`<E: Equatable>(forKey key: String) -> ControlProperty<E?> {
		let source = Observable.deferred { [weak defaults = self.base as UserDefaults] () -> Observable<E?> in
			let center = NotificationCenter.default
			let initial = defaults?.object(forKey: key) as? E
			let changes = center.rx.notification(UserDefaults.didChangeNotification)
				.map { _ in defaults?.object(forKey: key) as? E }
			
			return Observable.just(initial)
				.concat(changes)
				.distinctUntilChanged { (curry(==) <^> $0 <*> $1) ?? false }
		}
		
		let binder = Binder(self.base) { (defaults, value: E?) in
			defaults.set(value, forKey: key)
		}
		
		return ControlProperty(values: source, valueSink: binder)
	}
	
	func url(forKey key: String) -> ControlProperty<URL?> {
		let source = Observable.deferred { [weak defaults = self.base as UserDefaults] () -> Observable<URL?> in
			let center = NotificationCenter.default
			let initial = defaults?.url(forKey: key)
			let changes = center.rx.notification(UserDefaults.didChangeNotification)
				.map { _ in defaults?.url(forKey: key) }
			
			return Observable.just(initial)
				.concat(changes)
				.distinctUntilChanged { (curry(==) <^> $0 <*> $1) ?? false }
		}
		
		let binder = Binder(self.base) { (defaults, value: URL?) in
			defaults.set(value, forKey: key)
		}
		
		return ControlProperty(values: source, valueSink: binder)
	}
}

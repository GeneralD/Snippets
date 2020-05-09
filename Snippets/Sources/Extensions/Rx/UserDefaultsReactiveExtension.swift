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
import SwiftyUserDefaults

public extension Reactive where Base: UserDefaults {
	func `default`<E: Equatable>(_ type: E.Type, forKey key: String) -> Observable<E?> {
		let center = NotificationCenter.default
		let initial = base.object(forKey: key) as? E
		let changes = center.rx.notification(UserDefaults.didChangeNotification)
			.map { _ in self.base.object(forKey: key) as? E }
		
		return Observable<E?>.just(initial)
			.concat(changes)
			.distinctUntilChanged { previous, next in
				guard let previous = previous, let next = next else { return false }
				return previous == next
		}
	}
	
	func url(forKey key: String) -> Observable<URL?> {
		let center = NotificationCenter.default
		let initial = base.url(forKey: key)
		let changes = center.rx.notification(UserDefaults.didChangeNotification)
			.map { _ in self.base.url(forKey: key) }
		
		return Observable<URL?>.just(initial)
			.concat(changes)
			.distinctUntilChanged { previous, next in
				guard let previous = previous, let next = next else { return false }
				return previous == next
		}
	}
}

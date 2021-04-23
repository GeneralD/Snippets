//
//  ActivityIndicator.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/04/23.
//

import RxCocoa
import RxSwift

/**
 Enables monitoring of sequence computation.
 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator {
	private let lock = NSRecursiveLock()
	private let relay = BehaviorRelay(value: 0)
	private let loading: SharedSequence<SharingStrategy, Bool>

	public init() {
		loading = relay
			.asDriver()
			.map { $0 > 0 }
			.distinctUntilChanged()
	}

	func trackActivityOfObservable<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
		Observable.using { () -> ActivityToken<Source.Element> in
			self.increment()
			return .init(source: source.asObservable(), disposeAction: self.decrement)
		} observableFactory: {
			$0.asObservable()
		}
	}
}

extension ActivityIndicator: SharedSequenceConvertibleType {
	public typealias Element = Bool
	public typealias SharingStrategy = DriverSharingStrategy

	public func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
		loading
	}
}

private extension ActivityIndicator {
	func increment() {
		lock.lock()
		relay.accept(relay.value + 1)
		lock.unlock()
	}

	func decrement() {
		lock.lock()
		relay.accept(relay.value - 1)
		lock.unlock()
	}
}

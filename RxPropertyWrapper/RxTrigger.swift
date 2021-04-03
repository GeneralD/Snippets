import Foundation
import RxRelay
import RxSwift

@propertyWrapper
public struct RxTrigger<Value> {
	private let relay = PublishRelay<Value>()
	private let trigger: AnyObserver<Value>
	private let observable: Observable<Value>

	public init() {
		trigger = relay.asObserver()
		observable = relay.asObservable()
	}

	public var wrappedValue: AnyObserver<Value> {
		trigger
	}

	public var projectedValue: Observable<Value> {
		observable
	}
}

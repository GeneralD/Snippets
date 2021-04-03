import RxRelay
import RxSwift

@propertyWrapper
public struct RxProperty<Value> {
	private let relay: BehaviorRelay<Value>
	private let property: Observable<Value>

	public init(value: Value) {
		relay = .init(value: value)
		property = relay.asObservable()
	}

	public var wrappedValue: Observable<Value> {
		property
	}

	public var projectedValue: BehaviorRelay<Value> {
		relay
	}
}

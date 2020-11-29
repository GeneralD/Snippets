import RxSwift
import RxRelay

@propertyWrapper
struct RxProperty<Value> {
	
	private let relay: BehaviorRelay<Value>
	private let property: Observable<Value>
	
	init(value: Value) {
		relay = .init(value: value)
		property = relay.asObservable()
	}
	
	var wrappedValue: Observable<Value> {
		property
	}
	
	var projectedValue: BehaviorRelay<Value> {
		relay
	}
}

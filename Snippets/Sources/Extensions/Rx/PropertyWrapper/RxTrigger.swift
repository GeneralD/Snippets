import Foundation
import RxRelay
import RxSwift

@propertyWrapper
struct RxTrigger<Value> {
	
	private let relay = PublishRelay<Value>()
	private let trigger: AnyObserver<Value>
	private let observable: Observable<Value>
	
	init() {
		trigger = relay.asObserver()
		observable = relay.asObservable()
	}
	
	var wrappedValue: AnyObserver<Value> {
		trigger
	}
	
	var projectedValue: Observable<Value> {
		observable
	}
}

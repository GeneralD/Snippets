//
//  Fuse+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/28.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import Fuse
import RxSwift
import CollectionKit

extension Fuse: ReactiveCompatible {}

public extension Reactive where Base: Fuse {
	
	func search(text: String, in aList: [Fuseable], chunkSize: Int = 100) -> Single<[Fuse.FusableSearchResult]> {
		.create { observer in
			base.search(text, in: aList, chunkSize: chunkSize) { results in
				observer(.success(results))
			}
			return Disposables.create()
		}
	}
	
	func search<Item>(text: String, in aList: [Item], chunkSize: Int = 100, scoreSort: FuseSortByScore) -> Single<[Item]> where Item: Fuseable {
		search(text: text, in: aList, chunkSize: chunkSize)
			.map { $0.sorted(at: \.score, by: scoreSort.func) }
			.mapMany(\.index)
			.mapMany { aList[$0] }
	}
}

public enum FuseSortByScore {
	case asc, desc
}

fileprivate extension FuseSortByScore {
	var `func`: (Double, Double) -> Bool {
		switch self {
		case .asc:
			return (<)
		case .desc:
			return (>)
		}
	}
}

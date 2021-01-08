//
//  Observable+Just.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/01/09.
//  Copyright © 2021 ZYXW. All rights reserved.
//

import RxSwift

prefix operator *

public postfix func *<T>(_ value: T) -> Observable<T> {
	.just(value)
}

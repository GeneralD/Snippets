//
//  UIResponder+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/08/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIResponder {
	var isFirstResponder: Binder<Bool> {
		.init(base) { responder, beFirstResponder in
			if beFirstResponder {
				responder.becomeFirstResponder()
			} else {
				responder.resignFirstResponder()
			}
		}
	}
}

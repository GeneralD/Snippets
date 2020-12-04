//
//  UIResponder+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/08/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIResponder {
	
	var isFirstResponder: Binder<Bool> {
		.init(self.base) { responder, beFirstResponder in
			if beFirstResponder {
				responder.becomeFirstResponder()
			} else {
				responder.resignFirstResponder()
			}
		}
	}
}

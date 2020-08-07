//
//  UIViewReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/08/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public extension Reactive where Base: UIView {
	var isFirstResponder: Binder<Bool> {
		.init(self.base) { view, beFirstResponder in
			if beFirstResponder {
				view.becomeFirstResponder()
			} else {
				view.resignFirstResponder()
			}
		}
	}
}

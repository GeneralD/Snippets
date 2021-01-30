//
//  UIViewController+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/10.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIViewController {
	var present: Binder<UIViewController?> {
		.init(base) { presenter, presentee in
			switch (presenter.presentingViewController, presentee) {
			// dismiss current presented and then present new one
			case let (.some(v1), .some(v2)):
				guard v1 != v2 else { break }
				v1.dismiss(animated: true) {
					presenter.present(v2, animated: true)
				}
			// just present new one
			case let (.none, .some(v2)):
				presenter.present(v2, animated: true)
			// dismiss current presented
			case let (.some(v1), .none):
				v1.dismiss(animated: true)
			default:
				break
			}
		}
	}
}

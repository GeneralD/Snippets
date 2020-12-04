//
//  UIViewController+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/10.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
	
	var present: Binder<UIViewController?> {
		.init(base) { presenter, presentee in
			switch (presenter.presentingViewController, presentee) {
			// dismiss current presented and then present new one
			case (.some(let v1), .some(let v2)):
				guard v1 != v2 else { break }
				v1.dismiss(animated: true) {
					presenter.present(v2, animated: true)
				}
			// just present new one
			case (.none, .some(let v2)):
				presenter.present(v2, animated: true)
			// dismiss current presented
			case (.some(let v1), .none):
				v1.dismiss(animated: true)
			default:
				break
			}
		}
	}
}

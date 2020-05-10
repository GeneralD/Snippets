//
//  UIViewControllerReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/10.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
	var present: Binder<UIViewController> {
		.init(self.base) { vc, view in
			vc.present(view, animated: true)
		}
	}
}

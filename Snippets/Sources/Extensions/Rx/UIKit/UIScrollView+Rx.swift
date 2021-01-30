//
//  UIScrollView+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/12/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import EmptyDataSet_Swift
import RxCocoa
import RxSwift
import UIKit

public extension Reactive where Base: UIScrollView {
	var emptyDataSetView: Binder<(EmptyDataSetView) -> Void> {
		.init(base) { scroll, closure in
			scroll.emptyDataSetView(closure)
			scroll.reloadEmptyDataSet()
		}
	}
}

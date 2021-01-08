//
//  UIScrollView+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/12/05.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EmptyDataSet_Swift

public extension Reactive where Base: UIScrollView {
	
	var emptyDataSetView: Binder<(EmptyDataSetView) -> ()> {
		.init(base) { (scroll: Base, closure: @escaping(EmptyDataSetView) -> ()) in
			scroll.emptyDataSetView(closure)
			scroll.reloadEmptyDataSet()
		}
	}
}

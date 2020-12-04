//
//  UICollectionViewFlowLayout+Rx.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UICollectionViewFlowLayout {
	
    var itemSize: Binder<CGSize> {
		.init(self.base) { layout, size in
			layout.itemSize = size
        }
    }
}


//
//  UIPasteboardReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/08/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIPasteboard {
	
	var string: Binder<String?> {
		return Binder(base) { pasteboard, string in
			pasteboard.string = string
		}
	}
}

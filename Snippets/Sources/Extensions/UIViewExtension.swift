//
//  UIViewExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit

extension UIView {
	@IBInspectable open var cornerRadius: CGFloat {
		get {
			layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			clipsToBounds = newValue > 0
		}
	}
}

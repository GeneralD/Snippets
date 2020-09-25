//
//  EdgeInsetLabel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class EdgeInsetLabel: UILabel {
	
	var textInsets = UIEdgeInsets.zero {
		didSet { invalidateIntrinsicContentSize() }
	}
	
	override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
		let insetRect = bounds.inset(by: textInsets)
		let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
		return textRect.inset(by: -textInsets)
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: textInsets))
	}
}

extension EdgeInsetLabel {
	
	@IBInspectable
	var leftTextInset: CGFloat {
		set { textInsets.left = newValue }
		get { return textInsets.left }
	}
	
	@IBInspectable
	var rightTextInset: CGFloat {
		set { textInsets.right = newValue }
		get { return textInsets.right }
	}
	
	@IBInspectable
	var topTextInset: CGFloat {
		set { textInsets.top = newValue }
		get { return textInsets.top }
	}
	
	@IBInspectable
	var bottomTextInset: CGFloat {
		set { textInsets.bottom = newValue }
		get { return textInsets.bottom }
	}
}

fileprivate extension UIEdgeInsets {
	
	static prefix func -(insets: UIEdgeInsets) -> UIEdgeInsets {
		.init(top: -insets.top, left: -insets.left, bottom: -insets.bottom, right: -insets.right)
	}
}

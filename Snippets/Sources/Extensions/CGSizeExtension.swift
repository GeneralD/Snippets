//
//  CGSizeExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/29.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import CoreGraphics

public extension CGSize {
	static func square(_ i: Int) -> Self {
		.init(width: i, height: i)
	}

	static func square(_ f: CGFloat) -> Self {
		.init(width: f, height: f)
	}

	static func square(_ d: Double) -> Self {
		.init(width: d, height: d)
	}
}

//
//  ColorHash.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import UIKit

public class ColorHash {
	
	private let seed2: CGFloat = 137
	private let maxSafeInteger: Double = 9007199254740991.0 / 137.0
	private let full: CGFloat = 360
	
	public private(set) var str: String
	public private(set) var brightness: CGFloat
	public private(set) var saturation: CGFloat
	
	public init(_ str: String, _ saturation: CGFloat = 1, _ brightness: CGFloat = 1) {
		self.str = str
		self.saturation = saturation
		self.brightness = brightness
	}
	
	public var bkdrHash: CGFloat {
		"\(str)x".compactMap { String($0).unicodeScalars.first?.value }
			.reduce(into: CGFloat(0)) { accum, scl in
				if Double(accum) > maxSafeInteger { accum /= seed2 }
				accum *= accum
				accum += CGFloat(scl)
		}
	}
	
	public var color: UIColor {
		.init(hue: (bkdrHash.truncatingRemainder(dividingBy: (full - 1.0))) / full, saturation: saturation, brightness: brightness, alpha: 1.0)
	}
}

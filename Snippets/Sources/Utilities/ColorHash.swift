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
		
	public private(set) var string: String
	public private(set) var brightness: [CGFloat]
	public private(set) var saturation: [CGFloat]
	
	public init(seed: String, _ saturation: [CGFloat] = [CGFloat(0.35), CGFloat(0.5), CGFloat(0.65)], _ brightness: [CGFloat] = [CGFloat(0.35), CGFloat(0.5), CGFloat(0.65)]) {
		self.string = seed
		self.saturation = saturation
		self.brightness = brightness
	}
	
	private var bkdrHash: CGFloat {
		let seed1: CGFloat = 131
		let seed2: CGFloat = 137
		let maxSafeInteger = 9007199254740991 / seed2
		
		return string.compactMap { String($0).unicodeScalars.first?.value }
			.reduce(into: CGFloat(0)) { accum, scl in
				if accum > maxSafeInteger { accum /= seed2 }
				accum *= seed1
				accum += CGFloat(scl)
		}
	}
	
	private var HSB: (CGFloat, CGFloat, CGFloat) {
		let full: CGFloat = 360
		var hash = bkdrHash
		
		let h = hash.truncatingRemainder(dividingBy: full - 1.0) / full
		hash /= full
		let s = saturation[Int((full * hash).truncatingRemainder(dividingBy: CGFloat(saturation.count)))]
		hash /= CGFloat(saturation.count)
		let b = brightness[Int((full * hash).truncatingRemainder(dividingBy: CGFloat(brightness.count)))]
		return (h, s, b)
	}
	
	public var color: UIColor {
		let (h, s, b) = HSB
		return UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
	}
}

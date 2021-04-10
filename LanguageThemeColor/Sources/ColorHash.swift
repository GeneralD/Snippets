//
//  ColorHash.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import UIKit

struct ColorHash {
	let seed: String
	private let brightness: [CGFloat] = [0.35, 0.5, 0.65]
	private let saturation: [CGFloat] = [0.35, 0.5, 0.65]

	var color: UIColor {
		let (h, s, b) = hsb
		return .init(hue: h, saturation: s, brightness: b, alpha: 1.0)
	}
}

private extension ColorHash {
	var hsb: (CGFloat, CGFloat, CGFloat) {
		let full: CGFloat = 360
		let hash = bkdrHash

		let h = hash.truncatingRemainder(dividingBy: full - 1.0) / full
		let s = saturation[Int(hash.truncatingRemainder(dividingBy: CGFloat(saturation.count)))]
		let b = brightness[Int((hash / CGFloat(saturation.count)).truncatingRemainder(dividingBy: CGFloat(brightness.count)))]
		return (h, s, b)
	}

	var bkdrHash: CGFloat {
		let seed1: CGFloat = 131
		let seed2: CGFloat = 137
		let maxSafeInteger = 9_007_199_254_740_991 / seed2

		return seed.compactMap { String($0).unicodeScalars.first?.value }
			.reduce(into: CGFloat(0)) { accum, scl in
				if accum > maxSafeInteger { accum /= seed2 }
				accum *= seed1
				accum += CGFloat(scl)
			}
	}
}

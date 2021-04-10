//
//  UIColor+AutoAdjust.swift
//  LanguageThemeColor
//
//  Created by Yumenosuke Koukata on 2021/04/10.
//

import DynamicColor
import UIKit

public extension UIColor {
	var brightnessAdjusted: UIColor {
		guard let brightness = brightness else { return self }
		// Too dark?
		if (0 ..< 0.45).contains(brightness) {
			return lighter()
		}
		// Too light?
		if (0.85...).contains(brightness) {
			return darkened()
		}
		return self
	}

	var alphaAdjusted: UIColor {
		guard let brightness = brightness else { return self }
		return adjustedAlpha(amount: -brightness)
	}
}

private extension UIColor {
	var brightness: CGFloat? {
		var brightness: CGFloat = 0
		guard getHue(nil, saturation: nil, brightness: &brightness, alpha: nil) else { return nil }
		return brightness
	}
}

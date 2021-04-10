//
//  UIColor+LanguageTheme.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import DynamicColor
import DynamicJSON
import Hex
import UIKit

public extension UIColor {
	var comfortable: UIColor {
		// Get brightness
		var brightness: CGFloat = 0
		guard getHue(nil, saturation: nil, brightness: &brightness, alpha: nil) else { return self }
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

	static func themeColor(for language: String) -> UIColor {
		guard let hex = colorsJson?[language].string else { return .from(seed: language) }
		return .init(hex: hex)
	}

	static func from(seed: String) -> UIColor {
		ColorHash(seed: seed).color
	}

	private static let colorsJson: JSON? = {
		guard let url = R.file.language_colorsJson(),
		      let data = try? Data(contentsOf: url) else { return nil }
		return try? JSON(data: data)
	}()
}

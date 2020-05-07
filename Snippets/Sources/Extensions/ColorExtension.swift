//
//  ColorExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import Hex
import DynamicColor
import SwiftyJSON

public extension UIColor {
	
	var comfortable: UIColor {
		// Get brightness
		var brightness: CGFloat = 0
		guard getHue(nil, saturation: nil, brightness: &brightness, alpha: nil) else { return self }
		// Too dark?
		if (0..<0.45).contains(brightness) {
			return lighter()
		}
		// Too light?
		if (0.85...).contains(brightness) {
			return darkened()
		}
		return self
	}
	
	static func themeColor(for language: String) -> UIColor {
		guard let hex = colorsJson?[language].string else { return ColorHash(language).color }
		return UIColor(hex: hex)
	}
	
	private static let colorsJson = { () -> JSON? in
		guard let url = Bundle.main.url(forResource: "language_colors", withExtension: "json") else { return nil }
		guard let data = try? Data.init(contentsOf: url) else { return nil }
		return try? JSON(data: data)
	} ()
}

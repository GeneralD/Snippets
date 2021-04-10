//
//  UIColor+LanguageTheme.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import DynamicJSON
import Hex
import UIKit

public extension UIColor {
	static func themeColor(for language: String) -> UIColor {
		guard let hex = colorsJson?[language].string else { return .from(seed: language) }
		return .init(hex: hex)
	}
}

private extension UIColor {
	static func from(seed: String) -> UIColor {
		ColorHash(seed: seed).color
	}

	static let colorsJson: JSON? = {
		guard let url = R.file.language_colorsJson(),
		      let data = try? Data(contentsOf: url) else { return nil }
		return try? JSON(data: data)
	}()
}

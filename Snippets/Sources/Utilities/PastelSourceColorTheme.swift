//
//  PastelSourceColorTheme.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/07.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import Sourceful

struct PastelSourceColorTheme: SourceCodeTheme {
	
	public init() {}
	
	public let lineNumbersStyle: LineNumbersStyle? = .init(font: Font(name: "Menlo", size: 13)!, textColor: #colorLiteral(red: 0.06850594435, green: 0.4366983606, blue: 1, alpha: 1))
	
	public let gutterStyle: GutterStyle = .init(backgroundColor: #colorLiteral(red: 0.0973376611, green: 0.1433584707, blue: 0.1722420302, alpha: 1), minimumWidth: 32)
	
	public let font: Font = Font(name: "Menlo", size: 12)!
	
	public let backgroundColor: Color = #colorLiteral(red: 0.1530647022, green: 0.1530647022, blue: 0.1530647022, alpha: 1)
	
	public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
		switch syntaxColorType {
		case .plain:
			return #colorLiteral(red: 0.6281992662, green: 0.7925334909, blue: 1, alpha: 1)
			
		case .number:
			return #colorLiteral(red: 1, green: 0.7238472174, blue: 0.8219243077, alpha: 1)
		
		case .string:
			return #colorLiteral(red: 0.6872529771, green: 0.6763295318, blue: 1, alpha: 1)
			
		case .identifier:
			return #colorLiteral(red: 1, green: 0.937737156, blue: 0.6770503595, alpha: 1)
			
		case .keyword:
			return #colorLiteral(red: 0.7079717554, green: 1, blue: 0.730431033, alpha: 1)
			
		case .comment:
			return #colorLiteral(red: 0.4938922177, green: 0.5403475639, blue: 0.6957975042, alpha: 1)
			
		case .editorPlaceholder:
			return backgroundColor
		}
	}
}

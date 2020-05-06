//
//  SnnipetTableViewCell.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/06.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit
import Sourceful

class SnnipetTableViewCell: UITableViewCell {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var codeTextView: SyntaxTextView!
	@IBOutlet weak var syntaxLabel: UILabel!
	
	override func awakeFromNib() {
		codeTextView.theme = MySourceCodeTheme()
	}
}

fileprivate struct MySourceCodeTheme: SourceCodeTheme {
	
	public init() {}
	
	private static var lineNumbersColor: Color {
		.init(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
	}
	
	public let lineNumbersStyle: LineNumbersStyle? = LineNumbersStyle(font: Font(name: "Menlo", size: 13)!, textColor: .systemBlue)
	
	public let gutterStyle: GutterStyle = GutterStyle(backgroundColor: Color(red: 21/255.0, green: 22/255, blue: 31/255, alpha: 1.0), minimumWidth: 32)
	
	public let font = Font(name: "Menlo", size: 12)!
	
	public let backgroundColor = Color(red: 31/255.0, green: 32/255, blue: 41/255, alpha: 1.0)
	
	public func color(for syntaxColorType: SourceCodeTokenType) -> Color {
		
		switch syntaxColorType {
		case .plain:
			return .white
			
		case .number:
			return .init(red: 116/255, green: 109/255, blue: 176/255, alpha: 1.0)
			
		case .string:
			return .init(red: 211/255, green: 35/255, blue: 46/255, alpha: 1.0)
			
		case .identifier:
			return .init(red: 20/255, green: 156/255, blue: 146/255, alpha: 1.0)
			
		case .keyword:
			return .init(red: 215/255, green: 0, blue: 143/255, alpha: 1.0)
			
		case .comment:
			return .init(red: 69.0/255.0, green: 187.0/255.0, blue: 62.0/255.0, alpha: 1.0)
			
		case .editorPlaceholder:
			return backgroundColor
		}
		
	}
	
}

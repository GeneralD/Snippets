//
//  SyntaxTextViewReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Sourceful
import RxSwift
import RxCocoa

public extension Reactive where Base: SyntaxTextView {
    /// Bindable sink for `text` property.
    var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text ?? ""
        }
    }
}

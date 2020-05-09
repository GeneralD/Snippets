//
//  DefaultsKeyExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/09.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
	var documentUrl: DefaultsKey<URL?> { .init("documentUrl") }
}

//
//  SingleExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/28.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift

extension Single where Trait == SingleTrait, Element: Collection {
	
	public func mapMany<Result>(_ transform: @escaping (Element.Element) throws -> Result) -> Single<[Result]> {
		map { elements in
			try elements.map(transform)
		}
	}
}

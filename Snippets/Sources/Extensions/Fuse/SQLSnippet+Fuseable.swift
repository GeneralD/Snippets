//
//  SQLSnippet+Fuseable.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2021/04/04.
//

import Entity
import Fuse

extension SQLSnippet: Fuseable {
	public var properties: [FuseProperty] {
		// Fuse is a bit strange, smaller weight takes better score
		[title.map { FuseProperty(name: $0, weight: 0.1) },
		 body.map { FuseProperty(name: $0, weight: 0.8) },
		 syntax.map { FuseProperty(name: $0, weight: 0.1) }].compactMap { $0 }
	}
}

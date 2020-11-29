//
//  DisposeBagExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/11/29.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxSwift

extension DisposeBag {
	/// Convenience init which utilizes a function builder to let you pass in a list of
	/// disposables to make a DisposeBag of.
	public convenience init(@DisposableBuilder builder: () -> [Disposable]) {
		self.init(disposing: builder())
	}
	
	/// Convenience function allows a list of disposables to be gathered for disposal.
	public func insert(@DisposableBuilder builder: () -> [Disposable]) {
		self.insert(builder())
	}
	
	/// A function builder accepting a list of Disposables and returning them as an array.
	@_functionBuilder
	public struct DisposableBuilder {
		public static func buildBlock(_ disposables: Disposable...) -> [Disposable] {
			disposables
		}
	}
}

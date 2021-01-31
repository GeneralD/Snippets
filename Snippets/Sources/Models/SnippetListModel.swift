//
//  SnippetListModel.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/09/04.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

/// @mockable(typealias: Property = BehaviorSubject<URL?>)
protocol SnippetListModelProtocol {
	associatedtype Property: ObserverType, ObservableType where Property.Element == URL?
	var documentUrl: Property { get }
}

struct SnippetListModel: SnippetListModelProtocol {
	typealias Property = ControlProperty<URL?>
	var documentUrl: Property
}

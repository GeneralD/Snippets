//
//  TagListViewReactiveExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import RxSwift
import RxCocoa
import TagListView

public extension Reactive where Base: TagListView {
	
    var tags: Binder<[String]> {
		.init(self.base) { view, tags in
			view.removeAllTags()
            view.addTags(tags)
        }
    }
	
    var tag: Binder<String> {
		.init(self.base) { view, tag in
			view.removeAllTags()
            view.addTag(tag)
        }
    }
	
	var clear: Binder<()> {
		.init(base) { view, _ in
			view.removeAllTags()
		}
	}
}

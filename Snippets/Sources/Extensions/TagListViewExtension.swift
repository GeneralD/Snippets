//
//  TagListViewExtension.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import TagListView

public extension TagListView {
	var tags: [String] {
		get {
			tagViews.compactMap { $0.title(for: .init()) }
		}
		set {
			removeAllTags()
			addTags(newValue)
		}
	}

	var tagBackgroundColors: [UIColor] {
		get {
			tagViews.map(\.tagBackgroundColor)
		}

		set {
			tagViews.zip(newValue).forEach { tagView, color in
				tagView.tagBackgroundColor = color
			}
		}
	}
}

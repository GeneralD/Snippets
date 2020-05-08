//
//  PrimarySplitViewController.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/05/08.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit

class PrimarySplitViewController: UISplitViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		preferredDisplayMode = .allVisible
	}
}

extension PrimarySplitViewController: UISplitViewControllerDelegate {
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		true
	}
}

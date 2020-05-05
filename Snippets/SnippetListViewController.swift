//
//  SnippetListViewController.swift
//  Snippets
//
//  Created by Yumenosuke Koukata on 2020/04/30.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import UIKit

class SnippetListViewController: UIViewController {
	
	@IBOutlet private weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let fileManager = FileManager.default
		guard let icloudDocumentsUrl = fileManager.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents"),
		let files = try? fileManager.contentsOfDirectory(at: icloudDocumentsUrl, includingPropertiesForKeys: .none, options: []) else { return }
		print(files.reduce("") { $0 + $1.absoluteString + ", " })
//		files.first { url in url.lastPathComponent.removeFirst() }
		
//		FileManager.startDownloadingUbiquitousItem(at: url)
	}
}

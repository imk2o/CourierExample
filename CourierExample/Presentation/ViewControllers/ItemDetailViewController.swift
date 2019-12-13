//
//  ItemDetailViewController.swift
//  CourierExample
//
//  Created by k2o on 2019/12/12.
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController?.viewControllers.count == 1 {
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.dismiss(_:)))
            self.navigationItem.leftBarButtonItem = dismissButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadItem()
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadItem() {
        ItemStore.shared.getItemDetail(self.itemID) { (item) in
            self.imageView.image = item.image
            self.titleLabel.text = item.title
            self.detailTextView.text = item.detail
        }
    }
}

// MARK: - Routing
import Courier
extension ItemDetailViewController: Courier.DescribedDestinationScene {
    typealias Context = Int

    static let storyboardDescription = StoryboardDescription(
        name: "Main",
        identifier: "ItemDetailView"
    )
    
    // 遷移元から受け取ったパラメータを参照
    var itemID: Int { self.context }
}

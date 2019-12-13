//
//  PreferencesViewController.swift
//  CourierExample
//
//  Created by k2o on 2019/12/13.
//  Copyright © 2019 imk2o. All rights reserved.
//

import UIKit

class PreferencesViewController: UITableViewController {

    @IBOutlet weak var versionCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionCell.detailTextLabel?.text = version
        }
    }

    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Routing
import Courier
extension PreferencesViewController: Courier.DescribedDestinationScene {
    typealias Context = Void

    static let storyboardDescription = StoryboardDescription(name: "Preferences")
}

extension Routes {
    // どこからでも遷移可能なルートとして追加
    static let showPreferences = GlobalRoute<PreferencesViewController>()
}

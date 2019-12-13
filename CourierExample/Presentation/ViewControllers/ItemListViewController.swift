//
//  ItemListViewController.swift
//  CourierExample
//
//  Created by k2o on 2019/12/12.
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadItems()
    }

    private var items: [Item] = []
    private func loadItems(keyword: String = "") {
        ItemStore.shared.getItems(keyword: keyword) { (items) in
            self.items = items
            self.tableView.reloadData()
        }
    }
    
    func item(at indexPath: IndexPath) -> Item {
        return self.items[indexPath.row]
    }
    
    func item(for cell: UITableViewCell) -> Item? {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return nil
        }
        
        return self.item(at: indexPath)
    }
    
    // MARK: Outlets & Actions
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func showPageView(_ sender: Any) {
        // Segue Routeを使って画面遷移
        self.segueRoutes.showPageView.perform(with: (), from: self)
    }
    
    @IBAction func showPreferences(_ sender: Any) {
        // Global Routeを使って画面遷移
        Routes.showPreferences.perform(with: (), from: self)
    }
}

// MARK: - Routing
import Courier
extension ItemListViewController: Courier.DeclarativeRouting {
    struct SegueRoutes: Courier.SegueRouteDeclarations {
        // Segue Identifierが "showDetail" のAction Segueの遷移則
        private let showDetail = Courier.ActionSegueRoute<ItemDetailViewController> { (segue, sender) in
            // 選択したセルに対応するItemを求める
            let source = segue.source as! ItemListViewController
            guard
                let cell = sender as? UITableViewCell,
                let item = source.item(for: cell)
            else {
                fatalError()
            }
            
            return item.id
        }
        
        // Segue Identifierが "showPageView" のManual Segueの遷移則
        let showPageView = Courier.ManualSegueRoute<ItemPageContainerViewController>()
        
        static let shared: Self = .init()
        private init() {}
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Courierが代理でハンドリング
        self.segueRoutes.prepare(for: segue, sender: sender)
    }
}

// MARK: - UITableViewDataSource
extension ItemListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ItemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        cell.configure(with: self.item(at: indexPath))
        
        return cell
    }
}

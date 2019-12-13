//
//  ItemPageContainerViewController.swift
//  CourierExample
//
//  Created by k2o on 2019/12/12.
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ItemPageContainerViewController: UIViewController {
    private var pageViewDataSource: ItemPageViewDataSource!
    private var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // NOTE: Under Top BarsがONのとき、最初のページ表示直後に適用されない問題があるため
        DispatchQueue.main.async {
            let firstViewController = self.pageViewDataSource.firstViewController()
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
      
            self.navigationItem.title = firstViewController.title
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: ">>", style: .plain, target: self, action: #selector(self.toLastPage(_:))),
            UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(self.toFirstPage(_:)))
        ]
        
        ItemStore.shared.getAllItemIDs { (itemIDs) in
            self.pageViewDataSource = ItemPageViewDataSource(itemIDs: itemIDs)
            self.pageViewController.dataSource = self.pageViewDataSource
            self.pageViewController.delegate = self
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case .some("pageViewController") = segue.identifier {
            guard let pageViewController = segue.destination as? UIPageViewController else {
                fatalError()
            }
            
            self.pageViewController = pageViewController
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toFirstPage(_ sender: Any) {
        let firstViewController = self.pageViewDataSource.firstViewController()
        self.pageViewController.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    @objc func toLastPage(_ sender: Any) {
        let lastViewController = self.pageViewDataSource.lastViewController()
        self.pageViewController.setViewControllers([lastViewController], direction: .forward, animated: true, completion: nil)
    }
}

// MARK: - Routing
import Courier
extension ItemPageContainerViewController: Courier.DestinationScene {
    typealias Context = Void
}

// MARK: - UIPageViewControllerDelegate
extension ItemPageContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // NOTE: self.viewControllers?.firstが現在のページに対応するVC
        self.navigationItem.title = self.pageViewController.viewControllers?.first?.title
    }
}

// MARK: - ItemPageViewDataSource
class ItemPageViewDataSource: NSObject, UIPageViewControllerDataSource {
    let itemIDs: [Int]

    init(itemIDs: [Int]) {
        self.itemIDs = itemIDs
    }
    
    func firstViewController() -> UIViewController {
        return self.viewController(at: 0)
    }
    
    func lastViewController() -> UIViewController {
        return self.viewController(at: self.itemIDs.count - 1)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == 0 {
            return nil
            // Infinite loop
            //return self.viewController(at: self.numberOfPages - 1)
        }
        
        return self.viewController(at: index - 1)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == self.itemIDs.count - 1 {
            return nil
            // Infinite loop
            //return self.viewController(at: 0)
        }
        
        return self.viewController(at: index + 1)
    }
    
    private func viewController(at index: Int) -> UIViewController {
        let itemID = self.itemIDs[index]
        guard let viewController = ItemDetailViewController.instantiate(with: itemID) else {
            fatalError()
        }
        
        return viewController
    }
    
    private func indexOf(_ viewController: UIViewController) -> Int {
        guard
            let viewController = viewController as? ItemDetailViewController,
            let index = self.itemIDs.firstIndex(where: { $0 == viewController.itemID })
        else {
            fatalError()
        }
        
        return index
    }
}

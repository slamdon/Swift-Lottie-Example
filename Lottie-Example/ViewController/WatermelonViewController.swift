//
//  WatermelonViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class WatermelonViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var aTableView: UITableView!
    
    fileprivate var items = [String]()
    fileprivate var waterlemonView: LAAnimationView!
    fileprivate var watermelon: LAAnimationView!
    
    fileprivate var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.cornerRadius = 15
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        setupItems()
        
        aTableView.refreshControl = refreshControl
        
    }
    
    override func viewDidLayoutSubviews() {
        // setup animation view
        watermelon = LAAnimationView.animationNamed("Watermelon")
        watermelon.contentMode = .scaleAspectFit
        
        watermelon.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: view.bounds.height * 0.3 - 60)
        view.addSubview(watermelon)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playAnimation()
    }
    
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupItems() {
        var i = 0
        while i < 5 {
            items.insert(String(i), at: 0)
            i += 1
        }
    }
    
    func pullToRefresh() {
        // 加入新的數字
        let number = items.count
        items.insert(String(number), at: 0)
        
        playAnimation()
        
        refreshControl.endRefreshing()
        aTableView.reloadData()
    }
    
    func playAnimation() {
        watermelon.animationProgress = 0
        watermelon.play()
    }


}

// MARK: UITableViewDataSource
extension WatermelonViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "aCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "aCell")
        }
        cell?.textLabel?.text = items[indexPath.row]
        return cell!
    }
    
    
    
}

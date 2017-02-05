//
//  JSONExplorerViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/5.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit

protocol JSONExplorerViewControllerDelegate {
    func didSelect(animation:String)
}

class JSONExplorerViewController: UIViewController {
    var aTableView:UITableView!
    var jsonFiles = [String]()
    var delegate:JSONExplorerViewControllerDelegate?
    
    override func viewDidLoad() {
        jsonFiles = Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil, forLocalization: nil)
        
        aTableView = UITableView(frame: view.bounds)
        aTableView.delegate = self
        aTableView.dataSource = self
        view.addSubview(aTableView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(didTapClose))
    }
    
    override func viewDidLayoutSubviews() {
        aTableView.frame = view.bounds
    }
    
    func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDataSource
extension JSONExplorerViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonFiles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "aCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "aCell")
        }
        cell?.selectionStyle = .none
        
        let fileURL = jsonFiles[indexPath.row]
        let components = fileURL.components(separatedBy: "/")
        cell?.textLabel?.text = components.last
        return cell!
    }
    
    
}

// MARK: UITableViewDelegate
extension JSONExplorerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileURL = jsonFiles[indexPath.row]
        let components = fileURL.components(separatedBy: "/")
        delegate?.didSelect(animation: components.last!)
        
        dismiss(animated: true, completion: nil)
    }
    
}

//
//  HomeViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    fileprivate let items = ["Animation Exploreer", "Animated Keyboard", "Animated Transition Demo", "Watermelon Animation", "Read From Sandbox"]
    fileprivate var lottieLogo: LAAnimationView!
    
    override func viewDidLoad( ) {
        super.viewDidLoad()
        
        lottieLogo = LAAnimationView.animationNamed("LottieLogo1")
        lottieLogo.contentMode = .scaleAspectFill
        
        // logo被點後可以重播動畫
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playLottieAnimation))
        lottieLogo.addGestureRecognizer(tapGesture)
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        lottieLogo.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        lottieLogo.pause()
    }
    
    override func viewDidLayoutSubviews() {
        lottieLogo.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.3)
        view.addSubview(lottieLogo)
        
    }
    
    func playLottieAnimation() {
        lottieLogo.animationProgress = 0
        lottieLogo.play()
        
    }
    



}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
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
        cell?.selectionStyle = .none
        cell?.textLabel?.text = items[indexPath.row]
        return cell!
    }
    
}

// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        switch row {
        case 0:
            let VC = AnimationExplorerViewController(nibName: "AnimationExplorerViewController", bundle: nil)
            present(VC, animated: true, completion: nil)
            
        case 1:
            let VC = AnimationTypingViewController(nibName: "AnimationTypingViewController", bundle: nil)
            present(VC, animated: true, completion: nil)
            
        case 2:
            let VC = AnimationTransitionViewController(nibName: "AnimationTransitionViewController", bundle: nil)
            present(VC, animated: true, completion: nil)
            
        case 3:
            let VC = WatermelonViewController(nibName: "WatermelonViewController", bundle: nil)
            present(VC, animated: true, completion: nil)
            
        case 4:
            let VC = SandBoxViewController(nibName: "SandBoxViewController", bundle: nil)
            present(VC, animated: true, completion: nil)
            
        default:
            print("do nothing")
        }
        
        
    }
    
}

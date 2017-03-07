//
//  SandBoxViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/3/7.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class SandBoxViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    fileprivate var animationView: LAAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.layer.cornerRadius = 22
        

        
        setupSandbox()
    }
    
    override func viewDidLayoutSubviews() {
        // setup animation view
        let jsonFilePath: String = NSHomeDirectory() + "/Documents/sand.json"
        animationView = LAAnimationView(contentsOf: URL(fileURLWithPath: jsonFilePath))
        
        animationView.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: 200)
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        
        // add tap gesture for replaying animation
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAnimationView))
        animationView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playAnimation()
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // copy a file to sandbox, and load it with animation
    // 將一個文件複製到沙盒中，模擬從沙盒中讀取動畫的方法
    func setupSandbox() {
        let sourcePath = Bundle.main.path(forResource: "Watermelon", ofType: "json")!
        print(sourcePath)
        let targetPath: String = NSHomeDirectory() + "/Documents/sand.json"
        
        let fileManager = FileManager()
        
        do {
            try fileManager.copyItem(at: URL(fileURLWithPath: sourcePath), to: URL(fileURLWithPath: targetPath))
        } catch {
            print("failed to save file, maybe it is already exists")
        }
        
    }
    
    func didTapAnimationView() {
        playAnimation()
    }
    
    func playAnimation() {
        animationView.animationProgress = 0
        animationView.play()
    }

    
    

}

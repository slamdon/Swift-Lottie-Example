//
//  AnimationPresentedViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit

class AnimationPresentedViewController: UIViewController {

    @IBOutlet var dismissButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.layer.cornerRadius = 20
        
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

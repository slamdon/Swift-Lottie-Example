//
//  AnimationTransitionViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit

class AnimationTransitionViewController: UIViewController {

    @IBOutlet var presentButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
    fileprivate let transition = Transition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillLayoutSubviews() {
        presentButton.layer.cornerRadius = 20
        closeButton.layer.cornerRadius = 20
    }
    
    @IBAction func didTapPresent(_ sender: Any) {
        let VC = AnimationPresentedViewController(nibName: "AnimationPresentedViewController", bundle: nil)
        VC.transitioningDelegate = transition
        present(VC, animated: true, completion: nil)
    }
    
    @IBAction func didTapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}

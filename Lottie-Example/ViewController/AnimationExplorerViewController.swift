//
//  AnimationExplorerViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class AnimationExplorerViewController: UIViewController {
    enum ViewBackgroundColor:Int {
        case white
        case black
        case green
    }

    var toolBar:UIToolbar!
    var slider:UISlider?
    var laAnimation:LAAnimationView?
    var currentBGColor:ViewBackgroundColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tool bar
        toolBar = UIToolbar(frame: CGRect.zero)

        let openButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(open))
        let flx1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let openWebButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showURLInput))
        let flx2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let playButton = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(play(button:)))
        let flx3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let loopButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loop(button:)))
        let flx4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let zoomButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(setZoom(button:)))
        let flx5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let colorButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(setBGColor(button:)))
        let flx6 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        toolBar.items = [openButton, flx1, openWebButton, flx2, playButton, flx3, loopButton, flx4, zoomButton, flx5, colorButton, flx6, closeButton]
        view.addSubview(toolBar)
        resetAllButtons()
        
        // slider
        slider = UISlider(frame: CGRect.zero)
        slider?.addTarget(self, action: #selector(sliderChanged(slider:)), for: .valueChanged)
        slider?.minimumValue = 0
        slider?.maximumValue = 1
        view.addSubview(slider!)
        
        // other init
        currentBGColor = .white
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds = view.bounds
        toolBar.frame = CGRect(x: 0, y: bounds.size.height - 44, width: bounds.size.width, height: 44)
        var sliderSize = slider!.sizeThatFits(bounds.size)
        sliderSize.height += 12
        slider?.frame = CGRect(x: 10, y: toolBar.frame.minY - sliderSize.height, width: bounds.size.width - 20, height: sliderSize.height)
        laAnimation?.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: slider!.frame.minY)
        


    }
    
    func resetAllButtons() {
        slider?.value = 0
        for item in toolBar.items! {
            resetButton(button: item, hilighted: false)
        }
    }
    
    func resetButton(button:UIBarButtonItem, hilighted:Bool) {
        button.tintColor = hilighted ? UIColor.red : UIColor(red: 8/255, green: 76/255, blue: 97/255, alpha: 1)

    }
    
    func sliderChanged(slider:UISlider) {
        laAnimation?.animationProgress = CGFloat(slider.value)
    }
    
    func showJSONExplorer() {
        let vc = JSONExplorerViewController()
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        present(navController, animated: true, completion: nil)
        
    }
    
    func loadAnimationNamed(named:String) {
        laAnimation?.removeFromSuperview()
        laAnimation = nil
        resetAllButtons()
        
        laAnimation = LAAnimationView.animationNamed(named)
        laAnimation?.contentMode = .scaleAspectFit
        view.addSubview(laAnimation!)
        view.setNeedsLayout()
        
        laAnimation?.play()
        
    }
    
    func showMessage(message:String) {
        let messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.textAlignment = .center
        messageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        messageLabel.textColor = UIColor.white
        messageLabel.text = message
        
        var messageSize = messageLabel.sizeThatFits(view.bounds.size)
        messageSize.width += 14
        messageSize.height += 14
        messageLabel.frame = CGRect(x: 10, y: 30, width: messageSize.width, height: messageSize.height)
        messageLabel.alpha = 0
        view.addSubview(messageLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            messageLabel.alpha = 1
            
        }, completion: { finished in
            UIView.animate(withDuration: 0.3, delay: 1, options: .curveEaseInOut, animations: {
                messageLabel.alpha = 0
                
            }, completion: { fnished in
                messageLabel.removeFromSuperview()
            })
            
        })
        
    }

}

// MARK: UIToolBar
extension AnimationExplorerViewController {
    func open() {
        showJSONExplorer()
    }
    
    func showURLInput() {
        let alert = UIAlertController(title: "Load From URL", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter URL"
        })
        
        let load = UIAlertAction(title: "Load", style: .default, handler: { action in
            if alert.textFields?.first?.text != nil {
                self.loadAnimationNamed(named: (alert.textFields?.first?.text)!)
            }
            
        })
        
        alert.addAction(load)
        
        let close = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            // do nothing
        })
        
        alert.addAction(close)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func play(button:UIBarButtonItem) {
        if laAnimation!.isAnimationPlaying {
            resetButton(button: button, hilighted: false)
            laAnimation?.pause()
        } else {
            resetButton(button: button, hilighted: true)
            laAnimation?.play(completion: { finished in
                self.slider?.value = Float(self.laAnimation!.animationProgress)
                self.resetButton(button: button, hilighted: false)
                
            })
        }
    }
    
    func loop(button:UIBarButtonItem) {
        if laAnimation == nil {
            return
        }
        
        laAnimation?.loopAnimation = !laAnimation!.loopAnimation
        resetButton(button: button, hilighted: laAnimation!.loopAnimation)
        showMessage(message: laAnimation!.loopAnimation ? "Loop Enabled" : "Loop Disabled")
    }
    
    func setZoom(button:UIBarButtonItem) {
        if laAnimation == nil {
            return
        }
        
        switch laAnimation!.contentMode {
        case .scaleAspectFit:
            laAnimation?.contentMode = .scaleAspectFill
            showMessage(message: "Aspect Fill")
            
        case .scaleAspectFill:
            laAnimation?.contentMode = .scaleToFill
            showMessage(message: "Scale Fill")
            
        case .scaleToFill:
            laAnimation?.contentMode = .scaleAspectFit
            showMessage(message: "Aspect Fit")
        default:
            break
        }
    }
    
    func setBGColor(button:UIBarButtonItem) {
        switch currentBGColor! {
        case .white:
            currentBGColor = .black
            view.backgroundColor = UIColor.black
            
        case .black:
            currentBGColor = .green
            view.backgroundColor = UIColor(red: 50/255, green: 207/255, blue: 193/255, alpha: 1)
            
        case .green:
            currentBGColor = .white
            view.backgroundColor = UIColor.white
            
        }
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: JSONExplorerViewControllerDelegate
extension AnimationExplorerViewController: JSONExplorerViewControllerDelegate {
    func didSelect(animation: String) {
        loadAnimationNamed(named: animation)
    }
}

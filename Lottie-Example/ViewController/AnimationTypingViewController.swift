//
//  AnimationTypingViewController.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit

class AnimationTypingViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    var fontSlider:UISlider!
    
    // 其實只是一個帶有UICollectionView的UIView，用來顯示字母的動畫
    var textField:AnimatedTextField!
    
    // 用來接收使用者輸入的內容
    var typingField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        closeButton.layer.cornerRadius = 15
        
        textField = AnimatedTextField(frame: view.bounds)
        textField.setText(text: "Start Typing")
        view.addSubview(textField!)
        
        typingField = UITextField(frame: CGRect.zero)
        typingField.alpha = 0
        typingField.text = textField.text
        typingField.delegate = self
        view.addSubview(typingField)
        
        fontSlider = UISlider(frame: CGRect.zero)
        fontSlider.minimumValue = 18
        fontSlider.maximumValue = 128
        fontSlider.value = 36
        fontSlider.addTarget(self, action: #selector(sliderUpdated), for: .valueChanged)
        view.addSubview(fontSlider)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(notify:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(notify:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        typingField!.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 不顯示在畫面上
        typingField.frame = CGRect(x: 0,
                                   y: -100,
                                   width: view.bounds.size.width,
                                   height: 25)
        
        fontSlider.frame = CGRect(x: 10,
                                  y: closeButton.frame.maxY,
                                  width: view.bounds.size.width - 20,
                                  height: 44)
        
        textField.frame = CGRect(x: 0,
                                 y: fontSlider.frame.maxY,
                                 width: view.bounds.size.width,
                                 height: view.bounds.size.height - fontSlider.frame.maxY)
        
        
    }

    @IBAction func didTapClose(_ sender: Any) {
        typingField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func keyboardChanged(notify: Notification) {
        let userInfo = notify.userInfo
        let keyboardFrame:NSValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue

        textField.setScrollInsets(scrollInsets: UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.cgRectValue.size.height, right: 0))
    }
    
    func sliderUpdated() {
        textField.fontSize = Int(fontSlider.value)
    }

    
}

// MARK: UITextFieldDelegate
extension AnimationTypingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.textField.changeCharactersInRange(range: range, toString: string)
        return true
    }
}

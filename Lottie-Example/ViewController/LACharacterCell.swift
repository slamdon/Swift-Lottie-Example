//
//  LACharacterCell.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class LACharacterCell: UICollectionViewCell {
    var animationView: LAAnimationView?
    var character:String?
    
    func setCharacter(character:String) {
        var sanitizedCharacter = character.substring(to: character.index(character.startIndex, offsetBy: 1))
        let alphaSet = CharacterSet.letters
        var valid = sanitizedCharacter.trimmingCharacters(in: alphaSet).isEmpty
        
        if character == "BlinkingCursor" {
            sanitizedCharacter = character
        }
        
        if sanitizedCharacter == "," {
            sanitizedCharacter = "Comma"
            valid = true
        }
        if sanitizedCharacter == "'" {
            sanitizedCharacter = "Apostrophe"
            valid = true
        }
        
        if sanitizedCharacter == ":" {
            sanitizedCharacter = "Colon"
            valid = true
        }
        
        if sanitizedCharacter == "?" {
            sanitizedCharacter = "QuestionMark"
            valid = true
        }
        
        if sanitizedCharacter == "!" {
            sanitizedCharacter = "ExclamationMark"
            valid = true
        }

        if sanitizedCharacter == self.character {
            return
        }
        
        animationView?.removeFromSuperview()
        animationView = nil
        self.character = nil
        
        if !valid {
            return
        }
        
        self.character = sanitizedCharacter
        animationView = LAAnimationView.animationNamed(sanitizedCharacter)
        animationView?.contentMode = .scaleAspectFit
        
        let contentBounds = contentView.bounds
        self.animationView?.frame = CGRect(x: -contentBounds.size.width, y: 0, width: contentBounds.size.width * 3, height: contentBounds.size.height)
        
        contentView.addSubview(self.animationView!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentBounds = contentView.bounds
        animationView?.frame = CGRect(x: -contentBounds.size.width, y: 0, width: contentBounds.size.width * 3, height: contentBounds.size.height)
    }
    
    func displayCharacter(animated:Bool) {
        if animated {
            animationView?.play()
        } else if animationView?.animationProgress != 1 {
            OperationQueue.main.addOperation({
                self.animationView?.animationProgress = 1
            })
            
            
        }
    }
    
    func loopAnimation() {
        animationView?.loopAnimation = true
    }
}

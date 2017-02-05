//
//  AnimatedTextField.swift
//  Lottie-Example
//
//  Created by don chen on 2017/2/4.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit
import Lottie

class AnimatedTextField: UIView {
    
    fileprivate var collectionView:UICollectionView?
    
    fileprivate var layout = UICollectionViewFlowLayout()
    fileprivate var updatingCells = true
    fileprivate var letterSizes = [CGSize]()
    
    var text:String = ""
    
    private var _fontSize:Int = 36
    var fontSize: Int {
        get {
            return self._fontSize
        }
        
        set {
            self._fontSize = newValue
            computeLetterSizes()
            layout.invalidateLayout()
        }
    }
    
    fileprivate var scrollInsets:UIEdgeInsets?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView?.register(LACharacterCell.self, forCellWithReuseIdentifier: "char")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        addSubview(collectionView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView!.frame = bounds
    }
    
    fileprivate func characterAtIndexPath(indexPath:IndexPath) -> String{
        let nsText = text as NSString
        return nsText.substring(with: NSMakeRange(indexPath.row, 1)).uppercased() as String
    }
    
    fileprivate func computeLetterSizes() {
        var sizes = [CGSize]()
        let width = bounds.size.width
        var currentWidth:CGFloat = 0
        
        for i in 0..<text.characters.count {
            let nsString = text as NSString
            let letter = nsString.substring(with: NSMakeRange(i, 1)).uppercased() as String
            
            var letterSize = sizeOfString(string: letter)
            
            if letter == " " && i + 1 < text.characters.count {
                let cutString = nsString.substring(from: i + 1)
                let words = cutString.components(separatedBy: " ")
                
                if words.count > 0 {
                    let nextWordLength = sizeOfString(string: words.first!)
                    if currentWidth + nextWordLength.width + letterSize.width > width {
                        letterSize.width = floor(width - currentWidth)
                        currentWidth = 0
                    } else {
                        currentWidth += letterSize.width
                    }
                }
                
            } else {
                // cursor size
                currentWidth += letterSize.width
                if currentWidth >= width {
                    currentWidth = letterSize.width
                }
            }
            sizes.append(letterSize)
            
        }
        
        let cursorSize = sizeOfString(string: "w")
        sizes.append(cursorSize)
        letterSizes = sizes
    }
    
    fileprivate func sizeOfString(string:String) -> CGSize {
        let constraint = CGSize(width: 50, height: 50)
        var nsText = text as NSString
        nsText = nsText.uppercased as NSString
        
        var textSize = nsText.boundingRect(with: constraint,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: CGFloat(fontSize))],
                                           context: nil).size
        
        textSize.width += CGFloat(string.characters.count * 2)
        return textSize
    
    }
    
    func setText(text:String) {
        self.text = text
        computeLetterSizes()
        collectionView?.reloadData()
    }
    
    func scrollToBottom() {
        var bottomOffset = CGPoint(x: 0, y: collectionView!.contentSize.height - collectionView!.bounds.size.height + collectionView!.contentInset.bottom)
        bottomOffset.y = [bottomOffset.y,0].max()!
        collectionView?.setContentOffset(bottomOffset, animated: true)
    }
    
    func setScrollInsets(scrollInsets:UIEdgeInsets) {
        collectionView?.contentInset = scrollInsets
        scrollToBottom()
    }
    
    func changeCharactersInRange(range:NSRange, toString replacementString:String) {
        var newText = text
        
        // 如果有修改text
        if range.location > 0 {
            let aString = newText as NSString
            newText = aString.replacingCharacters(in: range, with: replacementString) as String

        }
        
        var addIndexes = [IndexPath]()
        var updateIndexes = [IndexPath]()
        var removeIndexes = [IndexPath]()
        
        for row in range.location..<newText.characters.count {
            if row < text.characters.count {
                updateIndexes.append(IndexPath(row: row, section: 0))
            } else {
                addIndexes.append(IndexPath(row: row, section: 0))
            }
        }
        
        if newText.characters.count <= text.characters.count {
            for row in newText.characters.count..<text.characters.count {
                removeIndexes.append(IndexPath(row: row, section: 0))
            }
        }

        
        updatingCells = true
        text = newText
        
        computeLetterSizes()
        collectionView?.performBatchUpdates({
            if !addIndexes.isEmpty {
                self.collectionView?.insertItems(at: addIndexes)
                print("insert")
            }
            if !updateIndexes.isEmpty {
                self.collectionView?.reloadItems(at: updateIndexes)
                print("update")
            }
            if !removeIndexes.isEmpty {
                self.collectionView?.deleteItems(at: removeIndexes)
                print("remove")
            }
            
        }, completion: { finished in
            self.updatingCells = false
        })
        
        scrollToBottom()
        
    }
    
    
}

// MARK: UICollectionViewDataSource
extension AnimatedTextField: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // +1是為了把光標(Cursor)加進去
        return text.characters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let charCell = collectionView.dequeueReusableCell(withReuseIdentifier: "char", for: indexPath) as! LACharacterCell
        return charCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let aCell = cell as! LACharacterCell
        if indexPath.row < text.characters.count {
            aCell.setCharacter(character: characterAtIndexPath(indexPath: indexPath))
            aCell.displayCharacter(animated: updatingCells)
        } else {
            aCell.setCharacter(character: "BlinkingCursor")
            aCell.loopAnimation()
            aCell.displayCharacter(animated: true)
            
        }
    }
}


// MARK: UICollectionViewFlowLayout
extension AnimatedTextField: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("collectionCell size \(letterSizes[indexPath.row])")
        return letterSizes[indexPath.row]
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

}




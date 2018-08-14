//
//  BodyTextView.swift
//  TTSAnimationDemo
//
//  Created by Yuske Fukuyama on 2018/08/13.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@IBDesignable
class BodyTextView: UITextView {
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    sharedInit()
  }
  
  override var intrinsicContentSize: CGSize {
    return super.intrinsicContentSize
  }
  
  private func sharedInit() {
    isUserInteractionEnabled = true
    isSelectable = true
    isEditable = false
    
    font = UIFont.systemFont(ofSize: 48, weight: .light)
    textAlignment = .justified

    textContainerInset = UIEdgeInsetsMake(16, 16, 16, 16)
    sizeToFit()
  }
}

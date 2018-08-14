//
//  PrimaryActionButton.swift
//  TTSAnimationDemo
//
//  Created by Yuske Fukuyama on 2018/08/13.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

@IBDesignable
class PrimaryActionButton: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    // fatalError("init(coder:) has not been implemented")
    super.init(coder: aDecoder)
    sharedInit()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    sharedInit()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    sharedInit()
  }
  
  override var intrinsicContentSize: CGSize {
    var size = super.intrinsicContentSize
    
    if let titleLabel = titleLabel {
      size.height = titleLabel.intrinsicContentSize.height * 2
      size.width = titleLabel.intrinsicContentSize.width * 2
    }
    
    return size
  }
  
  private func sharedInit() {
    backgroundColor = UIColor.primary
    titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
    setTitleColor(.white, for: .normal)
    setTitle("Tap to play", for: .normal)
  }
}

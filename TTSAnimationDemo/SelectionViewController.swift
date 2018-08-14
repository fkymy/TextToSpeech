//
//  SelectionViewController.swift
//  TTSAnimationDemo
//
//  Created by Yuske Fukuyama on 2018/08/13.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let identifier = segue.identifier else { return }
    guard let vc = segue.destination.contents as? DemoViewController else { return }
    guard let animation = Animation(rawValue: identifier) else { return }
    
    vc.title = identifier
    vc.animation = animation
  }
}

extension UIViewController {
  var contents: UIViewController {
    if let navVC = self as? UINavigationController {
      return navVC.visibleViewController ?? self
    }
    else {
      return self
    }
  }
}

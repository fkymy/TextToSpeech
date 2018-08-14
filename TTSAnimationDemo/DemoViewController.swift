//
//  DemoViewController.swift
//  TTSAnimationDemo
//
//  Created by Yuske Fukuyama on 2018/08/13.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

enum Animation: String {
  case first = "First"
  case second = "Second"
  case third = "Third"
}

class DemoViewController: UIViewController {

  var animation: Animation? {
    didSet {
      if view.window != nil {
        animate()
      }
    }
  }
  
  @IBOutlet weak var bodyTextView: BodyTextView!
  @IBOutlet weak var overlayTextView: BodyTextView!
  
  private var transcription: Transcription = Transcription.transcription()

  override func viewDidLoad() {
    super.viewDidLoad()
    bodyTextView.text = transcription.formattedString
    overlayTextView.text = ""
    overlayTextView.textColor = UIColor.primary
    overlayTextView.backgroundColor = .clear
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }
  
  private func animate() {
    guard let animation = animation else { return }
    print("animation started: \(animation.rawValue)")
    
    switch animation {
    case .first:

      let overlay = BodyTextView(frame: bodyTextView.frame, textContainer: bodyTextView.textContainer)
      overlay.text = transcription.formattedString
      overlay.textColor = UIColor.primary
      
      UIView.transition(from: bodyTextView, to: overlay, duration: 0.25, options: .transitionCrossDissolve)

      DispatchQueue.main.asyncAfter(deadline: .now() + transcription.duration) {
        print("animation finished.")
      }

    case .second:

      segments = transcription.segments
      let displaylink = CADisplayLink(target: self, selector: #selector(step))
      startTime = CACurrentMediaTime()
      displaylink.add(to: .current, forMode: .defaultRunLoopMode)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + transcription.duration) {
        displaylink.invalidate()
      }

    case .third:
      print("third")
    }
  }
  
  private var overlay: BodyTextView!
  private var startTime: CFTimeInterval!
  
  private var segments: [Segment] = []
  private var segmentsToDisplay: [Segment] = []
  private var overlayTextToDisplay = ""
  
  private var currentSegment: Segment?
  private var currentTimestamp: TimeInterval?

  @objc func step(displaylink: CADisplayLink) {
    // objective: display each segment for its duration.

    if self.segments.isEmpty {
      print("segments is empty")
    }
    
    // first time
    if self.currentSegment == nil {
      self.currentTimestamp = 0.1
      self.currentSegment = self.segments.removeFirst()
    }
    
    guard let currentSegment = self.currentSegment else { return }
    guard let currentTimestamp = self.currentTimestamp else { return }
    
    print("targetTimestamp: \(displaylink.targetTimestamp - startTime) vs. currentTimestamp: \(currentTimestamp)")
    
    if displaylink.targetTimestamp - startTime > currentTimestamp {
      self.overlayTextToDisplay += currentSegment.substring
      self.currentTimestamp = currentTimestamp + currentSegment.duration
      
      // can we keep going?
      if self.segments.count > 0 {
        let nextSegment = self.segments.removeFirst()
        self.currentSegment = nextSegment
      }
    }
    
    overlayTextView.text = overlayTextToDisplay
  }
}

extension String {
  var characterArray: [Character]{
    var characterArray = [Character]()
    for character in self.characters {
      characterArray.append(character)
    }
    return characterArray
  }
}

extension UITextView {
  func typeOn(string: String) {
    let characterArray = string.characterArray
    var characterIndex = 0
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
      if characterArray[characterIndex] != "$" {
        while characterArray[characterIndex] == " " {
          self.text.append(" ")
          characterIndex += 1
          if characterIndex == characterArray.count {
            timer.invalidate()
            return
          }
        }
        self.text.append(characterArray[characterIndex])
      }
      characterIndex += 1
      if characterIndex == characterArray.count {
        timer.invalidate()
      }
    }
  }
}

extension UIColor {
  static var primary: UIColor {
    return UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
  }
}

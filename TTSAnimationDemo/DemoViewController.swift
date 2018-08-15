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

  // MARK: Properties
  @IBOutlet weak var bodyTextView: BodyTextView!
  
  var animation: Animation? {
    didSet {
      if view.window != nil {
        animate()
      }
    }
  }
  
  private var transcription: Transcription? {
    didSet {
      if let transcription = transcription {
        segmentsToDisplay = transcription.segments
        bodyTextView.attributedText = NSMutableAttributedString(string: transcription.formattedString, attributes: bodyTextView.attributes)
      }
    }
  }

  // properties for displaylink animation
  private var startTime: CFTimeInterval!
  private var displayedAttributes: [NSAttributedStringKey: Any]!
  private var displayedSegments: [Segment]!
  private var segmentsToDisplay: [Segment]!
  private var currentSegment: Segment!
  private var currentTimestamp: TimeInterval!

  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    transcription = Transcription.transcription()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animate()
  }
}

// MARK: Animation
extension DemoViewController {
  
  private func animate() {
    guard let animation = animation else { return }

    print("animation started: \(animation.rawValue)")
    
    switch animation {
    case .first:
      
      let overlay = BodyTextView(frame: bodyTextView.frame, textContainer: bodyTextView.textContainer)
      overlay.text = segmentsToDisplay.reduce("", { $0 + $1.substring })
      overlay.textColor = UIColor.primary
      
      UIView.transition(from: bodyTextView, to: overlay, duration: 0.25, options: .transitionCrossDissolve)
      
    case .second:
      
      guard let font = bodyTextView.font else { return }
      let displaylink = CADisplayLink(target: self, selector: #selector(step))
      let attributes: [NSAttributedStringKey: Any] = [
        .font: font,
        .foregroundColor: UIColor.primary,
        .backgroundColor: UIColor.clear
      ]
      
      animate(with: displaylink, to: attributes)

    case .third:

      guard let font = bodyTextView.font else { return }
      let displaylink = CADisplayLink(target: self, selector: #selector(step))
      let attributes: [NSAttributedStringKey: Any] = [
        .font: font,
        .foregroundColor: UIColor.white,
        .backgroundColor: UIColor.darkGray
      ]
      
      animate(with: displaylink, to: attributes)
    }
  }
  
  private func animate(with displaylink: CADisplayLink, to attributes: [NSAttributedStringKey: Any]) {
    guard !segmentsToDisplay.isEmpty else {
      print("segments is empty")
      return
    }

    displayedAttributes = attributes
    currentSegment = segmentsToDisplay.removeFirst()
    currentTimestamp = 0

    displaylink.add(to: .current, forMode: .defaultRunLoopMode)
    startTime = CACurrentMediaTime()
  }
  
  @objc func step(displaylink: CADisplayLink) {
    // objective: change attributes for string range of each segment at the beginning of their duration

    if displaylink.targetTimestamp - startTime > currentTimestamp {
      
      guard let formattedString = transcription?.formattedString else { return }
      let range = (formattedString as NSString).range(of: currentSegment.substring)
      let attributedText = NSMutableAttributedString(attributedString: bodyTextView.attributedText)
      attributedText.addAttributes(displayedAttributes, range: range)
      
      bodyTextView.attributedText = attributedText
      currentTimestamp = currentTimestamp + currentSegment.duration
      
      if segmentsToDisplay.count > 0 {
        let nextSegment = segmentsToDisplay.removeFirst()
        currentSegment = nextSegment
      }
      else {
        displaylink.invalidate()
      }
    }
  }
}

// MARK: Extension util which generates NSAttributedString by text,font,color,backgroundColor
extension String {
  
}

extension NSAttributedString {
  class func generate(from text: String, font: UIFont = UIFont.systemFont(ofSize: 48, weight: .light), color: UIColor = .black, backgroundColor: UIColor = .clear) -> NSAttributedString {
    let atts: [NSAttributedStringKey : Any] = [.foregroundColor : color, .font : font, .backgroundColor : backgroundColor]
    return NSAttributedString(string: text, attributes: atts)
  }
}

extension UIColor {
  static var primary: UIColor {
    return UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
  }
}

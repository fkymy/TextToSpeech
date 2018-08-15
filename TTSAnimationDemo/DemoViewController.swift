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

  @IBOutlet weak var bodyTextView: BodyTextView!
  
  var animation: Animation? {
    didSet {
      if view.window != nil {
        animate()
      }
    }
  }
  
  private var transcription: Transcription! {
    didSet {
      if let transcription = transcription {
        bodyTextView.attributedText = NSMutableAttributedString(string: transcription.formattedString, attributes: bodyTextView.attributes)
        segmentsToPlay = transcription.segments
        segmentsPlayed = []
      }
    }
  }

  private var playedAttributes: [NSAttributedStringKey: Any]!
  private var startTime: CFTimeInterval!
  private var currentTimestamp: TimeInterval!
  private var segmentsToPlay: [Segment]!
  private var segmentsPlayed: [Segment]!
  private var currentSegment: Segment! {
    didSet {
      segmentsPlayed.append(currentSegment)
    }
  }

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

    switch animation {
    case .first:
      
      let overlay = BodyTextView(frame: bodyTextView.frame, textContainer: bodyTextView.textContainer)
      overlay.text = segmentsToPlay.reduce("", { $0 + $1.substring })
      overlay.textColor = .primary
      
      UIView.transition(from: bodyTextView, to: overlay, duration: 0.25, options: .transitionCrossDissolve)
      
    case .second:
      
      let displaylink = CADisplayLink(target: self, selector: #selector(step))
      let attributes: [NSAttributedStringKey: Any] = [
        .font: bodyTextView.font!,
        .foregroundColor: UIColor.primary,
        .backgroundColor: UIColor.clear
      ]
      
      animate(with: displaylink, to: attributes)

    case .third:

      let displaylink = CADisplayLink(target: self, selector: #selector(step))
      let attributes: [NSAttributedStringKey: Any] = [
        .font: bodyTextView.font!,
        .foregroundColor: UIColor.white,
        .backgroundColor: UIColor.darkGray
      ]
      
      animate(with: displaylink, to: attributes)
    }
  }
  
  private func animate(with displaylink: CADisplayLink, to attributes: [NSAttributedStringKey: Any]) {
    guard !segmentsToPlay.isEmpty else {
      return
    }

    playedAttributes = attributes
    currentSegment = segmentsToPlay.removeFirst()
    currentTimestamp = 0

    displaylink.add(to: .current, forMode: .defaultRunLoopMode)
    startTime = CACurrentMediaTime()
  }
  
  @objc func step(displaylink: CADisplayLink) {
    print("step: displaylinkTimestamp=\(displaylink.targetTimestamp - startTime), currentSegmentTimestamp=\(currentTimestamp!)")

    if displaylink.targetTimestamp - startTime > currentTimestamp {
      
      let attributedText = NSMutableAttributedString()
      let attributedTextPlayed = NSAttributedString(string: segmentsPlayed.reduce("", { $0 + $1.substring }), attributes: playedAttributes)
      let attributedTextToPlay = NSAttributedString(string: segmentsToPlay.reduce("", { $0 + $1.substring }), attributes: bodyTextView.attributes)
      
      attributedText.append(attributedTextPlayed)
      attributedText.append(attributedTextToPlay)

      UIView.transition(with: bodyTextView, duration: 0.15, options: .transitionCrossDissolve, animations: {
        self.bodyTextView.attributedText = attributedText
      }, completion: nil)
      
      currentTimestamp = currentTimestamp + currentSegment.duration
      
      if segmentsToPlay.count > 0 {
        let nextSegment = segmentsToPlay.removeFirst()
        currentSegment = nextSegment
      }
      else {
        displaylink.invalidate()
      }
    }
  }
}

extension UIColor {
  static var primary: UIColor {
    return UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0)
  }
}

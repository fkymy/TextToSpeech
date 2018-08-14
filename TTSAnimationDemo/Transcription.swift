//
//  Transcription.swift
//  TTSAnimationDemo
//
//  Created by Yuske Fukuyama on 2018/08/13.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import Foundation

// immitation model of SFTranscription
struct Transcription {
  
  var formattedString: String
  var segments: [Segment]
  
  var duration: TimeInterval {
    var duration: TimeInterval = 0
    segments.forEach { duration += $0.duration }
    return duration
  }
  
  static func transcription() -> Transcription{
    let segments = [
      Segment(substring: "あー", timestamp: 0.76, duration: 2.05),
      Segment(substring: "おはようございます", timestamp: 2.81, duration: 1.98),
      Segment(substring: "こんにちは", timestamp: 4.79, duration: 0.61),
      Segment(substring: "こんばんは", timestamp: 5.4, duration: 2.16),
      Segment(substring: "ヤッホー", timestamp: 7.56, duration: 2.61),
      Segment(substring: "朝", timestamp: 10.17, duration: 1.06),
      Segment(substring: "目", timestamp: 11.23, duration: 0.18),
      Segment(substring: "を", timestamp: 11.41, duration: 0.1),
      Segment(substring: "覚ます", timestamp: 11.51, duration: 0.42),
      Segment(substring: "とき", timestamp: 11.93, duration: 0.28),
      Segment(substring: "の", timestamp: 12.21, duration: 0.09),
      Segment(substring: "気持ちは", timestamp: 12.3, duration: 1.88),
      Segment(substring: "面白い", timestamp: 14.18, duration: 1.4),
    ]
    
    return Transcription(formattedString: "あーおはようございますこんにちはこんばんはヤッホー朝目を覚ますときの気持ちは面白い", segments: segments)
  }
}

struct Segment {
  
  var substring: String
  var timestamp: TimeInterval
  var duration: TimeInterval
}

//
//  CurrentScoreView.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class CurrentScoreView: UIView {

  var timerText: String = "READY!" {
    willSet {
      timerLabel.text = "\(newValue)"
    }
  }
  
  
  var scoreText: Int = 0 {
    willSet {
      scoreLabel.text = "\(newValue)"
    }
  }
  
  var scoreImage = UIImageView()
  private let timerLabel = UILabel()
  private let scoreLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseUI()
  }
  
  private func baseUI() {
    timerLabel.text = timerText
    timerLabel.textColor = #colorLiteral(red: 0.4882019353, green: 0.4882019353, blue: 0.4882019353, alpha: 1)
    timerLabel.font = UIFont(name: "BinggraeTaom", size: 32)
    timerLabel.font = .systemFont(ofSize: 32, weight: .bold)
    timerLabel.textAlignment = .center
    
    scoreImage.image = UIImage(named: "점수판")
    scoreImage.contentMode = .scaleToFill
    
    scoreLabel.text = "\(scoreText)"
    scoreLabel.textColor = .black
    scoreLabel.backgroundColor = .clear
    scoreLabel.font = UIFont(name: "BinggraeTaom", size: 24)
    scoreLabel.font = .systemFont(ofSize: 24, weight: .regular)
    scoreLabel.textAlignment = .center
    
    self.addSubview(scoreImage)
    self.addSubview(timerLabel)
    self.addSubview(scoreLabel)
    
    timerLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreImage.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    
    timerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
    timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    timerLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    timerLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
    
    scoreImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    scoreImage.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor, constant: -8).isActive = true
    scoreImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
    scoreImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
    
    scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    scoreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -4).isActive = true
    scoreLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.2).isActive = true
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

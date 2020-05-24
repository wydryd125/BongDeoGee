//
//  LevelSelectView.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol LevelSelectViewDelegate: class {
  func changeLevel(_ level: Int)
}

class LevelSelectView: UIView {
  
  weak var delegate: LevelSelectViewDelegate?
  
  private let scroleView = UIScrollView()
  private let levelView1 = UILabel()
  private let levelView2 = UILabel()
  private let levelView3 = UILabel()
  
  private let previousButton = UIButton()
  private let nextButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var levelIndex = 0 {
    didSet {
      scroleView.contentOffset.x = (CGFloat(levelIndex) * levelView1.bounds.width)
      delegate?.changeLevel(levelIndex)
    }
  }
  
  @objc func didTabButton(_ button: UIButton) {
    if button == previousButton {
      guard levelIndex != 0 else { return }
      levelIndex -= 1
    } else {
      guard levelIndex != 2 else { return }
      levelIndex += 1
    }
  }
  
  private func setUI() {
    
    scroleView.isPagingEnabled = true
    scroleView.showsHorizontalScrollIndicator = false
    
    levelView1.text = "LEVEL 1"
    levelView2.text = "LEVEL 2"
    levelView3.text = "LEVEL 3"
    
    previousButton.setImage(UIImage(named: "왼쪽"), for: .normal)
    previousButton.imageView?.contentMode = .scaleAspectFill
    previousButton.backgroundColor = .clear
    
    nextButton.setImage(UIImage(named: "오른쪽"), for: .normal)
    nextButton.imageView?.contentMode = .scaleAspectFill
    nextButton.backgroundColor = .clear
    
    previousButton.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
    nextButton.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
    
    [levelView1, levelView2, levelView3].forEach({
      $0.textAlignment = .center
      $0.font = UIFont(name: "BinggraeTaom", size: 30)
      scroleView.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.widthAnchor.constraint(equalTo: scroleView.widthAnchor).isActive = true
    })
    
    levelView1.leadingAnchor.constraint(equalTo: scroleView.leadingAnchor).isActive = true
    levelView2.leadingAnchor.constraint(equalTo: levelView1.trailingAnchor).isActive = true
    levelView3.leadingAnchor.constraint(equalTo: levelView2.trailingAnchor).isActive = true
    levelView3.trailingAnchor.constraint(equalTo: scroleView.trailingAnchor).isActive = true
    
    self.addSubview(scroleView)
    scroleView.translatesAutoresizingMaskIntoConstraints = false
    scroleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    scroleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    scroleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
    scroleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
    scroleView.widthAnchor.constraint(equalTo: levelView1.widthAnchor).isActive = true
    scroleView.heightAnchor.constraint(equalTo: levelView1.heightAnchor).isActive = true
    
    self.addSubview(previousButton)
    previousButton.translatesAutoresizingMaskIntoConstraints = false
    previousButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    previousButton.trailingAnchor.constraint(equalTo: scroleView.leadingAnchor, constant: 24).isActive = true
    previousButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    previousButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    
    self.addSubview(nextButton)
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    nextButton.centerYAnchor.constraint(equalTo: scroleView.centerYAnchor).isActive = true
    nextButton.leadingAnchor.constraint(equalTo: scroleView.trailingAnchor, constant: -24).isActive = true
    nextButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
    nextButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
  }
}


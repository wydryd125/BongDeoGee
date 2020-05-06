//
//  ControlView.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class ControlView: UIView {
  
  let startButton = UIButton()
  let cancelButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func baseUI() {
    
    startButton.setImage(UIImage(named: "시작"), for: .normal)
    startButton.imageView?.contentMode = .scaleAspectFit
    self.addSubview(startButton)
    
    startButton.translatesAutoresizingMaskIntoConstraints = false
    
    startButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    startButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    startButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    startButton.widthAnchor.constraint(equalTo: startButton.heightAnchor).isActive = true
  }
  
}

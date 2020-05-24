//
//  MainViewController.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {
  
  private var score: Int {
    didSet {
      if score != 0 {
        scoreLabel.text = "최고 점수! \(self.score) 점"
      } else {
        scoreLabel.text = "게임을 시작하세요!"
      }
    }
  }
  
  var gameLevel: GameSet {
    didSet {
      switch gameLevel {
      case .level1:
        if UserDefaults.standard.integer(forKey: UserDefaultKeys.score1) != 0 {
          scoreLabel.text = "최고 점수! \(UserDefaults.standard.integer(forKey: UserDefaultKeys.score1)) 점"
        } else {
          scoreLabel.text = "게임을 시작하세요!"
        }
      case .level2:
        if UserDefaults.standard.integer(forKey: UserDefaultKeys.score2) != 0 {
          scoreLabel.text = "최고 점수! \(UserDefaults.standard.integer(forKey: UserDefaultKeys.score2)) 점"
        } else {
          scoreLabel.text = "게임을 시작하세요!"
        }
      case .level3:
        if UserDefaults.standard.integer(forKey: UserDefaultKeys.score3) != 0 {
          scoreLabel.text = "최고 점수! \(UserDefaults.standard.integer(forKey: UserDefaultKeys.score3)) 점"
        } else {
          scoreLabel.text = "게임을 시작하세요!"
        }
      }
    }
  }
  
  private let nameLabel = UILabel()
  private let levelView = LevelSelectView()
  private let scoreLabel = UILabel()
  private let startButton = UIButton()
  
  init(name: String, level: GameSet, score: Int) {
    nameLabel.text = name
    self.score = score
    self.gameLevel = level
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 1, green: 0.9623679519, blue: 0.8724053502, alpha: 1)
    setLayout()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUI()
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      animations: {
        self.startButton.transform = CGAffineTransform(rotationAngle: .pi * 4)
    })
  }
  
  @objc func didTabStartButton(_ button: UIButton) {
    switch levelView.levelIndex {
    case 0:
      gameLevel = GameSet.level1
    case 1:
      gameLevel = GameSet.level2
    case 2:
      gameLevel = GameSet.level3
    default:
      break
    }
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      animations: {
        self.startButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
        
    })
    
    let tutorialView = TutorialViewController(level: self.gameLevel)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      tutorialView.modalPresentationStyle = .fullScreen
      tutorialView.modalTransitionStyle = .crossDissolve
      self.present(tutorialView, animated: true)
    }
  }
  
  private func changeScoreLabel() {
    switch gameLevel {
    case .level1:
      if UserDefaults.standard.integer(forKey: UserDefaultKeys.score1) == 0 {
        scoreLabel.text = "게임을 시작하세요!"
      } else {
        score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score1)
      }
    case .level2:
      if UserDefaults.standard.integer(forKey: UserDefaultKeys.score2) == 0 {
        scoreLabel.text = "게임을 시작하세요!"
      } else {
        score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score2)
      }
    case .level3:
      if UserDefaults.standard.integer(forKey: UserDefaultKeys.score3) == 0 {
        scoreLabel.text = "게임을 시작하세요!"
      } else {
        score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score3)
      }
    }
  }
  
  private func setUI() {
    levelView.delegate = self
    
    nameLabel.text = UserDefaults.standard.string(forKey: UserDefaultKeys.name)
    nameLabel.font = UIFont(name: "BinggraeTaom", size: 40)
    nameLabel.textColor = .darkGray
    
    scoreLabel.font = UIFont(name: "BinggraeTaom", size: 30)
    startButton.setImage(UIImage(named: "게임시작"), for: .normal)
    startButton.imageView?.contentMode = .scaleAspectFit
    startButton.backgroundColor = .clear
    startButton.addTarget(self, action: #selector(didTabStartButton(_:)), for: .touchUpInside)
    
    changeScoreLabel()
  }
  
  private func setLayout() {
    let guide = view.safeAreaLayoutGuide
    
    [nameLabel, levelView, scoreLabel, startButton].forEach({
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    })
    
    nameLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: Padding.padding).isActive = true
    
    levelView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: Padding.padding).isActive = true
    levelView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -Padding.padding).isActive = true
    levelView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Padding.padding).isActive = true
    levelView.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor, constant: -Padding.padding).isActive = true
    
    scoreLabel.topAnchor.constraint(equalTo: levelView.bottomAnchor, constant: Padding.padding).isActive = true
    
    startButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: Padding.padding).isActive = true
    startButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    startButton.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3).isActive = true
    startButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.65).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MainViewController: LevelSelectViewDelegate {
  func changeLevel(_ level: Int) {
    switch level {
    case 0:
      score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score1)
    case 1:
      score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score2)
    case 2:
      score = UserDefaults.standard.integer(forKey: UserDefaultKeys.score3)
    default:
      break
    }
  }
}

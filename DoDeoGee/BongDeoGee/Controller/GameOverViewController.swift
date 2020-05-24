//
//  GameOverViewController.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/03.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GameOverViewController: UIViewController {
  
  private var userLevel: Double
  private var userScore: Int
  
  private let backgroundView = UIImageView()
  private let statusLabel = UILabel()
  private let levelLabel = UILabel()
  private let scoreLabel = UILabel()
  private let endButton = UIButton()
  private let startButton = UIButton()
  
  private let minusLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUI(level: userLevel, score: userScore)
    setLayout()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    //        uploadToDatabase()
  }
  
  init(level: Double, score: Int) {
    userLevel = level
    userScore = score
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func didTabButton(_ button: UIButton) {
    switch userLevel {
    case GameSet.level1.interval:
      if userScore > UserDefaults.standard.integer(forKey: UserDefaultKeys.score1) {
        UserDefaults.standard.set(userScore, forKey: UserDefaultKeys.score1)
      }
    case GameSet.level2.interval:
      if userScore > UserDefaults.standard.integer(forKey: UserDefaultKeys.score2) {
        UserDefaults.standard.set(userScore, forKey: UserDefaultKeys.score2)
      }
    case GameSet.level3.interval:
      if userScore > UserDefaults.standard.integer(forKey: UserDefaultKeys.score3) {
        UserDefaults.standard.set(userScore, forKey: UserDefaultKeys.score3)
      }
    default:
      break
    }
    
    if button == endButton {
      self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    } else {
      if startButton.imageView?.image == UIImage(named: "다음") {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
      } else {
        dismiss(animated: true)
      }
    }
  }
  
  private func setUI(level: Double, score: Int) {
    switch userLevel {
    case GameSet.level1.interval:
      levelLabel.text = GameSet.level1.toString
      if score < 1000 {
        statusLabel.text = "아쉽네요 재도전!"
        minusLabel.text = "부족한 점수 : " + "\(1000-userScore)"
        startButton.setImage(UIImage(named: "재도전"), for: .normal)
      } else {
        statusLabel.text = "Wow SUCCESS!!"
        startButton.setImage(UIImage(named: "다음"), for: .normal)
      }
    case GameSet.level2.interval:
      levelLabel.text = GameSet.level2.toString
      if score < 3000 {
        statusLabel.text = "아쉽네요 재도전!"
        minusLabel.text = "부족한 점수 : " + "\(3000-userScore)"
        startButton.setImage(UIImage(named: "재도전"), for: .normal)
      } else {
        statusLabel.text = "Wow SUCCESS!!"
        startButton.setImage(UIImage(named: "다음"), for: .normal)
      }
    case GameSet.level3.interval:
      levelLabel.text = GameSet.level3.toString
      if score < 5000 {
        statusLabel.text = "아쉽네요 재도전!"
        minusLabel.text = "부족한 점수 : " + "\(5000-userScore)"
        startButton.setImage(UIImage(named: "재도전"), for: .normal)
      } else {
        statusLabel.text = "Wow SUCCESS!!"
        startButton.setImage(UIImage(named: "다음"), for: .normal)
      }
    default:
      print("이게 무슨 일....")
    }
    
    backgroundView.image = UIImage(named: "결과배경")
    backgroundView.contentMode = .scaleToFill

    statusLabel.font = UIFont(name: "BinggraeTaom", size: 40)
    
    levelLabel.font = UIFont(name: "BinggraeTaom", size: 30)
    
    scoreLabel.text = String(userScore)
    scoreLabel.font = UIFont(name: "BinggraeTaom", size: 40)
    
    minusLabel.font = UIFont(name: "BinggraeTaom", size: 20)
    
    endButton.setImage(UIImage(named: "종료"), for: .normal)
    endButton.backgroundColor = .clear
    endButton.imageView?.contentMode = .scaleAspectFit
    endButton.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
    
    
    startButton.backgroundColor = .clear
    startButton.imageView?.contentMode = .scaleAspectFit
    startButton.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
  }
  
  private func setLayout() {
    let guide = view.safeAreaLayoutGuide
    view.addSubview(backgroundView)
    backgroundView.translatesAutoresizingMaskIntoConstraints = false
    backgroundView.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
    backgroundView.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
    backgroundView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.95).isActive = true
    backgroundView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.8).isActive = true
    
    [statusLabel, levelLabel, scoreLabel, endButton, startButton, minusLabel].forEach({
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    endButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
    endButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
    endButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    endButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
    
    startButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
    startButton.leadingAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -8).isActive = true
    startButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    startButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
    
    [statusLabel, levelLabel, scoreLabel, minusLabel].forEach {
      $0.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    }
    
    scoreLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
    scoreLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
    scoreLabel.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    
    statusLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 48).isActive = true
    statusLabel.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    
    
    levelLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor).isActive = true
    levelLabel.bottomAnchor.constraint(equalTo: scoreLabel.topAnchor).isActive = true
//    levelLabel.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    
    minusLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor).isActive = true
    minusLabel.bottomAnchor.constraint(equalTo: endButton.topAnchor).isActive = true
//    minusLabel.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
    
  }
  
  //    private func uploadToDatabase() {
  //
  //        let values = ["userName": staticName ?? "noname",
  //                                 "userScore": "\(userScore)" ?? "0",
  //                                 "userLevel": "\(userLevel)" ?? "0",
  //                       ] as [String : Any]
  //
  //
  //        Database.database().reference().child("\(staticName)").setValue(values) { (error, ref) in
  //            if error != nil {
  //                print("Success Upload To Database")
  //                print(ref)
  //            }
  //        }
  //
  //        allLoadFromDatabase()
  //}
  //
  //    private func allLoadFromDatabase() {
  //
  //        var upperNameArray: Array<String> = []
  //
  //        Database.database().reference().observeSingleEvent(of: .value) { (snapshop) in
  //            upperNameArray = snapshop.value as? [String] ?? ["wrongName"]
  //
  //        }
  //
  //        for name in upperNameArray {
  //            Database.database().reference().child(name).observeSingleEvent(of: .value) { (snapshop) in
  //            let data = snapshop.value as? [String:Any] ?? ["fail":"fail"]
  //            guard let name = data["userName"] as? String else { return }
  //            guard let score = data["userScore"] as? String else {return }
  //            guard let level = data["userLevel"] as? String else { return }
  //            }
  //
  //        }
  //
  //    }
}

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
    //enter, startbutton
    @objc func didTabButton(_ button: UIButton) {
        switch levelIdx {
        case 0:
            if userScore > UserDefaults.standard.integer(forKey: UserDefault.score1) {
                UserDefaults.standard.set(userScore, forKey: UserDefault.score1)
            }
        case 1:
            if userScore > UserDefaults.standard.integer(forKey: UserDefault.score2) {
                UserDefaults.standard.set(userScore, forKey: UserDefault.score2)
            }
        case 2:
            if userScore > UserDefaults.standard.integer(forKey: UserDefault.score3) {
                UserDefaults.standard.set(userScore, forKey: UserDefault.score3)
            }
        default:
            break
        }
        //종료버튼이면
        if button == endButton {
           // 네번째 뷰이기 때문에 프레젠팅 3과, dismiss
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            if startButton.imageView?.image == UIImage(named: "다음") {
                self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                dismiss(animated: true)
            }
        }
    }
    //()안에 파라미터를 만들어주면 가져와서 사용할수 있음.
    private func setUI(level: Double, score: Int) {
        switch levelIdx + 1 {
        case 1:
            if score < 1000 {
                statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
                minusLabel.text = "부족한 점수 : " + "\(1000-userScore)"
            } else {
                statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음"), for: .normal)
            }
        case 2:
            if score < 4000 {
                statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
            } else {
                statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음"), for: .normal)
            }
        case 3:
            if score < 5000 {
                statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
            } else {
                statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음"), for: .normal)
            }
        default:
            break
        }
//
//        switch userLevel {
//        case GameSet.level1.interval:
//            levelLabel.text = GameSet.level1.toString
//        case GameSet.level1.interval:
//            levelLabel.text = GameSet.level2.toString
//        case GameSet.level1.interval:
//            levelLabel.text = GameSet.level3.toString
//        default:
//            break
//        }
//        
        backgroundView.image = UIImage(named: "결과배경")
        backgroundView.contentMode = .scaleToFill
        
        statusLabel.font = .systemFont(ofSize: 40)
        
//        levelLabel.text = "LEVEL " + String(levelIdx+1)
        levelLabel.font = .systemFont(ofSize: 30)
        
        scoreLabel.text = String(userScore)
        scoreLabel.font = .systemFont(ofSize: 40)
        
        minusLabel.font = .systemFont(ofSize: 20)
        
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
        
        statusLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Padding.padding * 3).isActive = true
        statusLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        levelLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Padding.padding).isActive = true
        levelLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: Padding.padding).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        minusLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: Padding.padding/2).isActive = true
        minusLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        
        endButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
        endButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
        endButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
        endButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
        
        startButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
        startButton.leadingAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -8).isActive = true
        startButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
        startButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
    }
}

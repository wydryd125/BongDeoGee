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
    
    private var userLevel: Int
    private var userScore: Int
    
    private let backgroundView = UIImageView()
    private let statusLabel = UILabel()
    private let levelLabel = UILabel()
    private let scoreLabel = UILabel()
    private let endButton = UIButton()
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI(level: userLevel, score: userScore)
        setLayout()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //        uploadToDatabase()
    }
    
    init(level: Int, score: Int) {
        userLevel = level
        userScore = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTabButton(_ button: UIButton) {
        print("버튼")
        if userScore > UserDefaults.standard.integer(forKey: UserDefault.score) {
            UserDefaults.standard.set(userScore, forKey: UserDefault.score)
        }
        
        if button == endButton {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            if  startButton.imageView?.image == UIImage(named: "다음단계") {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
                // dismiss 로는 게임 첫 화면 상태가 안나오는데? 
            }
        }
    }
    
    private func setUI(level: Int, score: Int) {
        switch level {
        case 1:
            if score < 1000 {
                     statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
            } else {
             statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음단계"), for: .normal)
            }
        case 2:
            if score < 4000 {
                     statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
            } else {
                statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음단계"), for: .normal)
            }
        case 3:
            if score < 5000 {
                statusLabel.text = "아쉽네요 재도전!"
                startButton.setImage(UIImage(named: "재도전"), for: .normal)
            } else {
                statusLabel.text = "Wow SUCCESS!!"
                startButton.setImage(UIImage(named: "다음단계"), for: .normal)
            }
        default:
            break
        }
        
        backgroundView.image = UIImage(named: "결과배경")
        backgroundView.contentMode = .scaleToFill
        
//        statusLabel.text = "SUCCESS / FAIL"
        statusLabel.font = .systemFont(ofSize: 40)
    
        
        levelLabel.text = "LEVEL " + String(userLevel)
        levelLabel.font = .systemFont(ofSize: 30)
        
        scoreLabel.text = String(userScore)
        scoreLabel.font = .systemFont(ofSize: 40)
        
        endButton.setImage(UIImage(named: "종료"), for: .normal)
        endButton.backgroundColor = .clear
        endButton.imageView?.contentMode = .scaleAspectFit
        endButton.addTarget(self, action: #selector(didTabButton(_:)), for: .touchUpInside)
        
        
//        startButton.setTitle("재도전/다음 단계", for: .normal)
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
        
        [statusLabel, levelLabel, scoreLabel, endButton, startButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        statusLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Padding.padding * 3).isActive = true
        statusLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        levelLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: Padding.padding).isActive = true
        levelLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        scoreLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: Padding.padding).isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        endButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
        endButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
        endButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
        endButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
        
        startButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -32).isActive = true
        startButton.leadingAnchor.constraint(equalTo: backgroundView.centerXAnchor, constant: -8).isActive = true
        startButton.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.2).isActive = true
        startButton.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.4).isActive = true
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

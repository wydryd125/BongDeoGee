//
//  TutorialViewController.swift
//  BongDeoGee
//
//  Created by 정유경 on 2020/02/07.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {

    private let level: GameSet
    
    private let levelView = LevelSelectView()
    private let backgroudImage = UIImageView()
    private let startButton = UIButton()
    private let tutorialLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9623679519, blue: 0.8724053502, alpha: 1)
    }
    // 뷰컨트롤러를 생성할때 필수값(레벨)을 받아와서 생성함. 오버라이드 인잇이 안되기 때문에 이렇게 작성함.
    // 오버라이드 인잇되긴하는데 복잡쓰
    // 생성자 다시보기
    init(level: GameSet) {
        self.level = level
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        backgroudImage.image = UIImage(named: "튜토리얼")
        backgroudImage.contentMode = .scaleToFill
        
        tutorialLabel.backgroundColor = .clear
        tutorialLabel.numberOfLines = 0
        tutorialLabel.text = "✔️  두더지 터치 시 100점!\n✔️  봉쓰 터치 시 0점이에요 조심!\n✔️  갑자기 튀어나오는 업쓰를 잡으면 보너스 300! 빠빵"
        tutorialLabel.font = UIFont.systemFont(ofSize: 20)
        tutorialLabel.textColor = .black
        
        startButton.setImage(UIImage(named: "고고"), for: .normal)
        startButton.imageView?.contentMode = .scaleAspectFit
        startButton.addTarget(self, action: #selector(didTabStartButton(_:)), for: .touchUpInside)
        startButton.backgroundColor = .clear
        
    }
    func setLayout() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(backgroudImage)
        backgroudImage.translatesAutoresizingMaskIntoConstraints = false
        backgroudImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        backgroudImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: -64).isActive = true
        backgroudImage.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 1).isActive = true
        backgroudImage.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(tutorialLabel)
        tutorialLabel.translatesAutoresizingMaskIntoConstraints = false
        tutorialLabel.topAnchor.constraint(equalTo: guide.centerYAnchor, constant: -24).isActive = true
        tutorialLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        tutorialLabel.heightAnchor.constraint(equalTo: backgroudImage.heightAnchor, multiplier: 0.3).isActive = true
        tutorialLabel.widthAnchor.constraint(equalTo: backgroudImage.widthAnchor, multiplier: 0.7).isActive = true
        
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.topAnchor.constraint(equalTo: backgroudImage.bottomAnchor, constant: -4).isActive = true
        startButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func didTabStartButton(_ button: UIButton) {
        let startOrigin = startButton.transform
        let gameVC = GameViewController(level: level)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.startButton.transform = self.startButton.transform.scaledBy(x: 4, y: 4)
                self.startButton.transform = startOrigin

        })
        //지금으로부터 3초뒤에 {code} 실행~
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.modalTransitionStyle = .crossDissolve
        self.present(gameVC, animated: true)

        }
    }
}


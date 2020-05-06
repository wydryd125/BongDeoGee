//
//  FirebongViewController.swift
//  bongdeozi
//
//  Created by 정유경 on 2020/02/02.
//  Copyright © 2020 정유경. All rights reserved.
//

import UIKit

class FirebongViewController: UIViewController {
    
    private let bongImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setUI()
        setConstrain()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fireBongAni()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: false)
            guard let gameVc = self.presentingViewController as? GameViewController else { return }
            gameVc.startTimer()
        }
    }
  
    private func fireBongAni() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.repeat, .autoreverse],
            animations: {
                self.bongImage.transform = self.bongImage.transform.scaledBy(x: 1.2, y: 1.2)
        })
    }
    
    private func setUI() {
        bongImage.contentMode = .scaleAspectFill
        bongImage.image = UIImage(named: "화난봉쓰")
        view.addSubview(bongImage)
    }
  
    private func setConstrain(){
        let guide = view.safeAreaLayoutGuide
        bongImage.translatesAutoresizingMaskIntoConstraints = false
        bongImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        bongImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor).isActive = true
        bongImage.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.6).isActive = true
        bongImage.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.8).isActive = true
    }
}

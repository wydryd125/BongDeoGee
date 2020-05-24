//
//  LaunchViewController.swift
//  BongDeoGee
//
//  Created by 정유경 on 2020/02/05.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "런치")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        UIView.animate(withDuration: 1, delay: 1, options: [], animations: {
            self.imageView.alpha = 0
        }) { (_) in
            let vc = StartSettingViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
}

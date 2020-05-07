//
//  FirstSettingViewController.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/04.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class StartSettingViewController: UIViewController {
    // - InfoSettingView ("게임을 시작합니다" / [이름 입력창] / [버튼])
    
    private var name: String?
    
    private let inputLabel = UILabel()
    private let inputTextField = UITextField()
    private let guideLine = UILabel()
    private let okButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9623679519, blue: 0.8724053502, alpha: 1)
        
        //firebase signIn시 사용
        Auth.auth().signIn(withEmail: "test@naver.com", password: "123456") { (result, err) in
            if err == nil {
                print("로그인 성공")
            }
        }
        setUI()
        setLayout()
    }
    // 오케이버튼
    @objc func didTabOkButton(_ button: UIButton) {
        
        //inputTextField에 텍스트가 있으면 name에 넣음
        guard let name = inputTextField.text else { return }
       // 유저디폴트에 저장
        UserDefaults.standard.set(name, forKey: "name")
       //!!!!!!!!!!!!!
        staticName = name
        
        if name == "" {
            alertAction()
        } else {
            //()안의 정보를 가지고 메이뷰로 쓩
            let mainVC = MainViewController(name: name, level: GameSet.level1, score: 0)
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true)
        }
    }
    
    private func okButtonOrigin() {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            animations: {
                self.okButton.transform = CGAffineTransform(rotationAngle: .zero)
        })
    }
    
    private func okButtonAni() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            animations: {
                self.okButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
                self.okButton.transform = self.okButton.transform.scaledBy(x: 1.2, y: 1.2)
        })
    }
    //이름 텍스트필드에 아무것도 없으면 뜨는 알럿
    private func alertAction() {
        let alert = UIAlertController(title: "이름을 입력하세요", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            self.inputTextField.becomeFirstResponder()
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func setUI() {
        inputLabel.text = "게임을 시작합니다"
        inputLabel.font = .systemFont(ofSize: 30)
        inputLabel.textAlignment = .center
        
        inputTextField.placeholder = "이름을 입력하세요"
        inputTextField.font = .systemFont(ofSize: 30)
        inputTextField.borderStyle = .none
        inputTextField.delegate = self
        
        guideLine.backgroundColor = .lightGray
        
        okButton.setImage(UIImage(named: "입장"), for: .normal)
        okButton.imageView?.contentMode = .scaleAspectFit
        okButton.backgroundColor = .clear
        okButton.addTarget(self, action: #selector(didTabOkButton(_:)), for: .touchUpInside)
    }
    
    private func setLayout() {
        let guide = view.safeAreaLayoutGuide
        
        [inputLabel, inputTextField, guideLine, okButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        inputLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: Padding.padding * 2).isActive = true
        inputLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        inputTextField.topAnchor.constraint(equalTo: inputLabel.bottomAnchor, constant: Padding.padding).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: inputLabel.leadingAnchor, constant: Padding.padding).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: inputLabel.trailingAnchor, constant: -Padding.padding).isActive = true
        
        guideLine.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 10).isActive = true
        guideLine.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        guideLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        guideLine.widthAnchor.constraint(equalTo: inputTextField.widthAnchor, multiplier: 1.2).isActive = true
        
        
        okButton.topAnchor.constraint(equalTo: guideLine.bottomAnchor, constant: Padding.padding * 1.5).isActive = true
        okButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        okButton.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3).isActive = true
        okButton.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.6).isActive = true
    }
}

extension StartSettingViewController: UITextFieldDelegate {
    //텍스트필드가 바뀔때마다~~~~
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //텍스트필드가 비어있음면?
        if textField.text?.isEmpty == true {
            self.okButton.setImage(UIImage(named: "입장"), for: .normal)
            okButtonOrigin()
        //비어있지 않으면 게임시작 고고
        } else {
            self.okButton.setImage(UIImage(named: "게임시작"), for: .normal)
            okButtonAni()
        }
    }
    //텍스트필드 리턴키를 누르면
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //아무것도 없으면 아무일도 일어나지않음
        if textField.text == "" {
            return false
        } else {
            //텍스타가 있으면 키보드내려감.
            textField.resignFirstResponder()
            return true
        }
    }
}

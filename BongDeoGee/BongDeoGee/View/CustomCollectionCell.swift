//
//  CustomCollectionCell.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/02.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

protocol CustomCollectionCellDelegate: class {
  func buttonAction(cell: CustomCollectionCell)
  func actionButton(image: UIImageView)
  func cellChangeAction(isSelected: Bool, cell: CustomCollectionCell)
}

class CustomCollectionCell: UICollectionViewCell {
  
  static let identifier = "cell"
  
  weak var delegate: CustomCollectionCellDelegate?
 
  let oopsImage = UIImageView()
  let imageView = UIImageView()
  private let selectButton = UIButton()
  
  override var isSelected: Bool {
    didSet {
      delegate?.cellChangeAction(isSelected: self.isSelected, cell: self)
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    baseUI()
    selectButton.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func didTabButton() {
    delegate?.buttonAction(cell: self)
    delegate?.actionButton(image: imageView)
  }
  
  private func baseUI() {
    imageView.image = UIImage(named: "두더지없음")
    imageView.contentMode = .scaleAspectFill
    
    contentView.addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    oopsImage.image = UIImage(named: "웁쓰")
    oopsImage.contentMode = .scaleAspectFill
    oopsImage.alpha = 0
    
    contentView.addSubview(oopsImage)
    oopsImage.translatesAutoresizingMaskIntoConstraints = false
    oopsImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
    oopsImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    oopsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5).isActive = true
    oopsImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
    
    contentView.addSubview(selectButton)
    selectButton.translatesAutoresizingMaskIntoConstraints = false
    selectButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    selectButton.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    selectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    selectButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
  }
  
}

//
//  ViewController.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/02.
//  Copyright © 2020 Jisng. All rights reserved.
//
import AudioToolbox.AudioServices
import AVFoundation
import UIKit

//var levelIdx = 0

class GameViewController: UIViewController {
  
  var itemCount = 3
  var gameLevel: Double
  
  
  private let randomBounsFrame = [
    CGRect(x: 70, y: 80, width: 110, height: 110),
    CGRect(x: 60, y: 200, width: 100, height: 100),
    CGRect(x: 300, y: 120, width: 100, height: 100),
    CGRect(x: 260, y: 360, width: 110, height: 110),
    CGRect(x: 60, y: 700, width: 100, height: 100),
    CGRect(x: 280, y: 700, width: 100, height: 100)
  ]
  
  var tempIndexPath: Int?
  
  var bbongsStatus = false
  
  var score: Int = 0 {
    willSet {
      currentScoreView.scoreText = newValue
    }
  }
  
  private var gameTimer = Timer()
  private var itemTimer = Timer()
  
  var counter: Int = 0 {
    willSet {
      currentScoreView.timerText = TimeToString(counter: newValue)
    }
  }
  
  var sec = 0 {
    willSet {
      gameOver(time: newValue)
    }
  }
  var nano = 0
  
  private var isState = true
  
  
  private var soundEffect = AVAudioPlayer()
  private let backgroundImage = UIImageView()
  private let currentScoreView = CurrentScoreView()
  private let controlView = ControlView()
  private var bonusWordImage = UIImageView()
  private var bonusButton = UIButton()
  private let misBackgroundView = UIView()
  
  private let layout = UICollectionViewFlowLayout()
  lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
  
  init(level: GameSet) {
    gameLevel = level.interval
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionViewUI()
    autolayout()
    backgroundViewUI()
    collectionView.allowsMultipleSelection = false
    controlAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reloadData()
  }
  
  private func reloadData() {
    counter = 00
    sec = 00
    nano = 00
    score = 00
    controlView.startButton.setImage(UIImage(named: "시작"), for: .normal)
    currentScoreView.timerText = "READY!"
    collectionView.reloadData()
  }
  
  private func BGMPlayer() {
    let url = Bundle.main.url(forResource: "큰일났어요", withExtension: "mp3")
    if let url = url {
      do {
        soundEffect = try AVAudioPlayer(contentsOf: url)
        soundEffect.prepareToPlay()
        soundEffect.play()
      }
      catch let error {
        print(error.localizedDescription)
      }
    }
  }
  
  
  private func gameOver(time: Int) {
    if time == 30 {
      let gameOverVC = GameOverViewController(level: gameLevel, score: score)
      gameOverVC.modalPresentationStyle = .fullScreen
      present(gameOverVC, animated: false)
      stopTimer()
    }
  }
  
  private func controlAction() {
    controlView.startButton.addTarget(self, action: #selector(didControlAction(_:)), for: .touchUpInside)
  }
  
  @objc func didControlAction(_ button: UIButton) {
    switch button {
    case controlView.startButton:
      if isState {
        BGMPlayer()
        startTimer()
        controlView.startButton.setImage(UIImage(named: "정지"), for: .normal)
      } else {
        stopTimer()
        soundEffect.stop()
        controlView.startButton.setImage(UIImage(named: "시작"), for: .normal)
        controlView.startButton.contentMode = .scaleAspectFit
        collectionView.visibleCells.forEach { $0.isSelected = false }
      }
      isState.toggle()
    default:
      break
    }
  }
  
  private func stopTimer() {
    gameTimer.invalidate()
    itemTimer.invalidate()
    counter = 0
    sec = 0
    nano = 0
    score = 0
    currentScoreView.timerText = "READY!"
  }
  
  func startTimer() {
    gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
    itemTimer = Timer.scheduledTimer(timeInterval: gameLevel, target: self, selector: #selector(itemAction), userInfo: nil, repeats: true)
  }
  
  @objc func timeAction() {
    counter += 1
  }
  
  private func TimeToString (counter: Int) -> String {
    sec = (counter / 100) % 60
    nano = counter % 100
    return String(format: "%02d", self.sec) + " : " + String(format: "%02d", self.nano)
  }
  
  @objc func itemAction() {
    if tempIndexPath == 5 {
      bbongsPopUp()
    } else {
      randomPopUp()
    }
    
    let temp = [1, 2, 5, 7]
    if sec % 3 == temp.randomElement() {
      //            print(sec)
      bonusPopUp()
    } else {
      bonusButton.isHidden = true
    }
  }
  
  private func makeItemCount() -> [Int] {
    var array: [Int] = []
    for i in 0...(itemCount*itemCount-1) {
      array.append(i)
    }
    return array
  }
  
  private func bonusPopUp() {
    guard let tempRandomFrame = randomBounsFrame.randomElement() else { return }
    bonusButton.frame = tempRandomFrame
    bonusButton.isHidden = false
  }
  
  private func bbongsPopUp() {
    guard let intIndex = makeItemCount().randomElement() else { return }
    if intIndex == tempIndexPath {
      bbongsPopUp()
    } else {
      let indexPath = randomIndex()
      collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
      bbongsStatus = true
    }
  }
  
  private func randomPopUp() {
    let indexPath = randomIndex()
    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
    bbongsStatus = false
  }
  
  private func randomIndex() -> IndexPath {
    guard let randomInt = makeItemCount().randomElement() else { return IndexPath(item: 0, section: 0)}
    if tempIndexPath == randomInt {
      return randomIndex()
    } else {
      tempIndexPath = randomInt
      return IndexPath(item: randomInt, section: 0)
    }
  }
  
  @objc func bonusButtonDidTap() {
    let bonusOrigin = bonusWordImage.transform
    
    score += 300
    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      options: [.autoreverse],
      animations: {
        self.bonusWordImage.alpha = 1
        self.bonusWordImage.transform = self.bonusWordImage.transform.scaledBy(x: 2.5, y: 2.5)
        self.bonusWordImage.alpha = 0
        self.bonusWordImage.transform = bonusOrigin
    })
  }
  
  private func backgroundViewUI() {
    backgroundImage.image = UIImage(named: "배경")
    backgroundImage.contentMode = .scaleToFill
    
    misBackgroundView.backgroundColor = #colorLiteral(red: 0.5560160216, green: 0.1580937134, blue: 0.1131936957, alpha: 1).withAlphaComponent(0.5)
    misBackgroundView.alpha = 0
    
    bonusButton.setImage(UIImage(named: "보너스"), for: .normal)
    bonusButton.imageView?.contentMode = .scaleAspectFit
    bonusButton.addTarget(self, action: #selector(bonusButtonDidTap), for: .touchUpInside)
    view.addSubview(bonusButton)
    
    bonusWordImage.image = UIImage(named: "보너스문구")
    bonusWordImage.contentMode = .scaleAspectFill
    bonusWordImage.alpha = 0
  }
  
  private func collectionViewUI() {
    let itemsInLine: CGFloat = CGFloat(itemCount)
    let spacing:CGFloat = 1
    let insets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    let cWidth = collectionView.bounds.width
    let contentSize = cWidth - insets.left - insets.right - (spacing * itemsInLine - 1)
    let itemSize = (contentSize / itemsInLine).rounded(.down)
    
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    layout.sectionInset = insets
    layout.itemSize = CGSize(width: itemSize, height: itemSize)
    
    collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCollectionCell.identifier)
    collectionView.backgroundColor = .clear
    collectionView.dataSource = self
    collectionView.isScrollEnabled = false
  }
  
  private func autolayout() {
    let guide = view.safeAreaLayoutGuide
    [backgroundImage, currentScoreView, collectionView, controlView, misBackgroundView, bonusWordImage].forEach {
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    currentScoreView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    currentScoreView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    currentScoreView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    currentScoreView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.24).isActive = true

    collectionView.topAnchor.constraint(equalTo: currentScoreView.bottomAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
    
    controlView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
    controlView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    controlView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    controlView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    controlView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.14).isActive = true

    misBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    misBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    misBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    misBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    bonusWordImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 120).isActive = true
    bonusWordImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -100).isActive = true
    bonusWordImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
    bonusWordImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
  }
}

extension GameViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return makeItemCount().count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.identifier, for: indexPath) as? CustomCollectionCell else { return UICollectionViewCell() }
    cell.delegate = self
    return cell
  }
  
}

extension GameViewController: CustomCollectionCellDelegate {
  
  func actionButton(image: UIImageView) {
    switch image.image {
    case UIImage(named: "두더지"):
      //            print("dodo")
      break
    case UIImage(named: "봉쓰"):
      vibrate()
    //            print("Fire")
    case UIImage(named: "보너스"):
      //            print("Bonus")
      break
    case UIImage(named: "두더지없음"):
      vibrate()
      if gameTimer.isValid == true {
        misBackgroundView.alpha = 1
        UIView.animate(withDuration: 0.3) {
          self.misBackgroundView.alpha = 0
        }
      }
    //            print("땡")
    default:
      break
    }
  }
  
  private func vibrate() {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
  }
  
  func cellChangeAction(isSelected: Bool, cell: CustomCollectionCell) {
    if isSelected {
      if bbongsStatus {
        cell.imageView.image = UIImage(named: "봉쓰")
        cell.imageView.contentMode = .scaleAspectFit
      } else   {
        cell.imageView.image = UIImage(named: "두더지")
        cell.imageView.contentMode = .scaleAspectFill
      }
    } else {
      cell.imageView.image = UIImage(named: "두더지없음")
      cell.imageView.contentMode = .scaleAspectFill
    }
    
  }
  func reStartTimer() {
    gameTimer.fire()
    itemTimer.fire()
  }
  
  func buttonAction(cell: CustomCollectionCell) {
    guard
      let tapIndexPath = collectionView.indexPath(for: cell),
      let selectIndexPath = collectionView.indexPathsForSelectedItems?.first
      else { return }
    
    if tapIndexPath == selectIndexPath {
      switch cell.imageView.image {
      case UIImage(named: "두더지"):
        score += 100
        
        let dodeogeeOrigin = cell.oopsImage.transform
        cell.oopsImage.alpha = 1
        cell.oopsImage.transform = cell.oopsImage.transform.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(
          withDuration: 0.3,
          delay: 0,
          animations: {
            cell.oopsImage.alpha = 0
            cell.oopsImage.transform = dodeogeeOrigin
        })
      case UIImage(named: "봉쓰"):
        score = 0
        gameTimer.invalidate()
        itemTimer.invalidate()
        let fireVC = FirebongViewController()
        fireVC.modalPresentationStyle = .overCurrentContext
        present(fireVC, animated: false)
        reStartTimer()
      default:
        break
      }
    } else {
      score -= 100
    }
  }
  
}

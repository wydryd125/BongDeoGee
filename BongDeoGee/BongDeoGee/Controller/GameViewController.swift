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
//!!!!!!!!!!!!!!!!
var levelIdx = 0

class GameViewController: UIViewController {

    var itemCount = 3
    var gameLevel: Double
    
    // 보너스업쓰가 랜덤 위치로 나오게 하기 위해 배열에 위치 여러곳을 넣어둠.
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
    var level = 1
    
    // 점수는 계속 입력받아야하므로 willset으로 값 받기... 그리고 그 값(newValue)은 currentScoreView.scoreText에 쏙!
    var score: Int = 0 {
        willSet {
            currentScoreView.scoreText = newValue
        }
    }
    //타이머들
    private var gameTimer = Timer()
    private var itemTimer = Timer()
    
    //시간도 계속 바뀌므로 willset으로... 그리고 그 값(newValue)은 string으로 바꿔서 currentScoreView.timerText 쏙!
    var counter: Int = 0 {
        willSet {
            currentScoreView.timerText = TimeToString(counter: newValue)
        }
    }
    //!!!!!!!!!!!!!!!!!!!
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
    //
    init(level: GameSet) {
        gameLevel = level.interval
        print(gameLevel)
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
        //여러가지 셀선택이 가능함 우리 봉더지에는 필요없음. 기본값이 false여서 사용하지 않으면 굳이 안써줘두댐ㅎ
        collectionView.allowsMultipleSelection = false
        controlAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // 시간 및 이미지, 점수 초기화를 위해 viewWillAppear에 ^^!!
        reloadData()
    }
    
    private func reloadData() {
        // timetostring을 써주었기때문에 0만 써놔두댐
        counter = 00
        sec = 0
        nano = 0
        score = 0
        controlView.startButton.setImage(UIImage(named: "시작"), for: .normal)
        currentScoreView.timerText = "READY!"
        //reloadData - 데이터를 초기화하는 함수, 기본적으로 있음.
        collectionView.reloadData()
    }
    //비지엠 나오게하는 함수~ 그냥 똑같이쓰세염
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

    // 게임오버하느 함수
    private func gameOver(time: Int) {
        // 타이머가 15초가 되면~~~~~~~~~~ 게임레벨이랑 스코어 들고 가버릴거야~~~~~~~~~~~~
        if time == 15 {
            let gameOverVC = GameOverViewController(level: gameLevel, score: score)
            gameOverVC.modalPresentationStyle = .fullScreen
            present(gameOverVC, animated: false)
            stopTimer()
        }
    }
   // 플레이버트 눌렀을떄~~
    private func controlAction() {
        controlView.startButton.addTarget(self, action: #selector(didControlAction(_:)), for: .touchUpInside)
    }
  // 플레이 버튼 누르면 일어나는 일~~~~~~~~~~~₩
    @objc func didControlAction(_ button: UIButton) {
        switch button {
        case controlView.startButton:
            if isState /*true*/{
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
    //타이머 멈추는...
    private func stopTimer() {
        gameTimer.invalidate()
        itemTimer.invalidate()
        counter = 0
        sec = 0
        nano = 0
        score = 0
        currentScoreView.timerText = "READY!"
    }
    //타치머 시작하는..
    func startTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timeAction), userInfo: nil, repeats: true)
        itemTimer = Timer.scheduledTimer(timeInterval: gameLevel, target: self, selector: #selector(itemAction), userInfo: nil, repeats: true)
    }
    @objc func timeAction() {
        counter += 1
    }
    // 시간을 문자열로~
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
        
        //보너스업쓰를 랜덤한 시간으로 띄우기 위함...
        let temp = [1, 2, 5, 7]
        if sec % 3 == temp.randomElement() {
            bonusPopUp()
        } else {
            bonusButton.isHidden = true
        }
    }
    //[0,1,2,3,4,5,6,7,8] 9게
    private func makeItemCount() -> [Int] {
        var array: [Int] = []
                      //3*3-1 = 8
        for i in 0..<itemCount*itemCount {
            array.append(i)
        }
        return array //[0,1,2,3,4,5,6,7,8]
    }
    //보너스 업쓰를 띄우는...
    private func bonusPopUp() {
        //랜덤보너스프레임중 랜덤한 위치를 tempRandomFrame 요기에 넣어줌
        guard let tempRandomFrame = randomBounsFrame.randomElement() else { return }
        //이제 보너스업스는 랜덤한 위치에 자리한다...!
        bonusButton.frame = tempRandomFrame
        bonusButton.isHidden = false
    }
    //봉쓰를 띄우는....
    private func bbongsPopUp() {
        //[0,1,2,3,4,5,6,7,8]중 랜덤값을 intIndex에 넣어둠.
        guard let intIndex = makeItemCount().randomElement() else { return }
       //[0,1,2,3,4,5,6,7,8]중 랜덤값이 [0,1,2,3,4,5,6,7,8]중 랜덤값과 같으면 봉쓰업
        if intIndex == tempIndexPath {
            bbongsPopUp()
        } else {
            let indexPath = randomIndex()
            //selectItem - > isSectected true로 만들어줌, randomIndex값이 indexPath값이 되어 그 인덱스만 true가됨ㄴ...
            //뭔말이야 씨아런미로암너ㅏㅇ뢈노란올ㄴㅇ
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
            // 봉쓰이미지를 나오게~~
            bbongsStatus = true
        }
    }
    //랜덤으로 띄우는 함수
    private func randomPopUp() {
        //indexPath는 랜덤한 숫자를 뽑는 함수에서 나온 값~~~~~~~~~
        let indexPath = randomIndex()
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        // 두더지 이미지 나오게~~~
        bbongsStatus = false
    }
    //랜덤한 숫자를 뽑기위한 함수
    private func randomIndex() -> IndexPath {
        //randomInt = [0,1,2,3,4,5,6,7,8]중 랜덤값
        guard let randomInt = makeItemCount().randomElement() else { return IndexPath(item: 0, section: 0)}
       // tempIndexPath = [0,1,2,3,4,5,6,7,8]중 랜덤값 과 randomInt가 같으면
        if tempIndexPath == randomInt {
           //랜덤숫자 리턴
            return randomIndex()
        } else {
            //같지않으면 tempIndexPath값은 randomInt값을...
            //값을 여기에 넣어줘서 중복방지를 해줌.
            tempIndexPath = randomInt
            return IndexPath(item: randomInt, section: 0)
        }
    }
    //보너스 업스를 누르면~~~~~~~~~~~
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
        
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(misBackgroundView)
        misBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        misBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        misBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        misBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        misBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(currentScoreView)
        currentScoreView.translatesAutoresizingMaskIntoConstraints = false
        currentScoreView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        currentScoreView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        currentScoreView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        currentScoreView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.24).isActive = true
        
        view.addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        controlView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        controlView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        controlView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.16).isActive = true
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: currentScoreView.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.55).isActive = true
        
        view.addSubview(bonusWordImage)
        bonusWordImage.translatesAutoresizingMaskIntoConstraints = false
        bonusWordImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 120).isActive = true
        bonusWordImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -100).isActive = true
        bonusWordImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
        bonusWordImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
//델리게이트사용~~~~~~~~~~~~~~~~~~~~~~~>_<
extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //makeItemCount() -> [0,1,2,3,4,5,6,7,8]
        return makeItemCount().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.identifier, for: indexPath) as? CustomCollectionCell else { return UICollectionViewCell() }
        cell.delegate = self
        return cell
    }
    
}
//CustomCollectionCell에서 만든 함수 가져와서 사용
extension GameViewController: CustomCollectionCellDelegate {
    //버튼이 눌렸을때 일어나는
    func actionButton(image: UIImageView) {
        //버튼에 있는 이미지가~ 봉쓰와 두더지없음 이면 vibrate() 함수실행
        switch image.image {
        case UIImage(named: "두더지"):
            break
        case UIImage(named: "봉쓰"):
            vibrate()

        case UIImage(named: "보너스"):

            break
        case UIImage(named: "두더지없음"):
            vibrate()
            //게임타이너가 유효하면(ture) 밑에처럼 실행하겠다. 아니면 실행할거 없음.
            if gameTimer.isValid == true {
                misBackgroundView.alpha = 1
                UIView.animate(withDuration: 0.3) {
                    self.misBackgroundView.alpha = 0
                }
            }
        default:
            break
        }
    }
    // 진동을 주기위한 함수, 맨 위 상단 import AudioToolbox.AudioServices 넣어줘야함.
    private func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    // 셀 변경을 위한 액션
    func cellChangeAction(isSelected: Bool, cell: CustomCollectionCell) {
        //isSelected true
        if isSelected {
            //  bbongsStatus true
            if bbongsStatus {
                cell.imageView.image = UIImage(named: "봉쓰")
                cell.imageView.contentMode = .scaleAspectFit
            //  bbongsStatus false
            } else   {
                cell.imageView.image = UIImage(named: "두더지")
                cell.imageView.contentMode = .scaleAspectFill
            }
            //isSelected false
        } else {
            cell.imageView.image = UIImage(named: "두더지없음")
            cell.imageView.contentMode = .scaleAspectFill
        }
        
    }
    //타이머 재실행 함수
    func reStartTimer() {
        gameTimer.fire()
        itemTimer.fire()
    }
    //커스텀셀 눌렀을때
    func buttonAction(cell: CustomCollectionCell) {
        guard // 내가 눌렀을때 셀의 인덱스패스를 가져오기 위함.
            let tapIndexPath = collectionView.indexPath(for: cell),
            // 두더지나, 봉쓰처럼 현재 나오는 것들 중 첫번째 인덱스패스를 가져옴
            let selectIndexPath = collectionView.indexPathsForSelectedItems?.first
            else { return }
        
        //내가 누른것과, 두더지 or 봉쓰가 같았을때
        if tapIndexPath == selectIndexPath {
            switch cell.imageView.image {
            case UIImage(named: "두더지"):
                score += 100
                //웁스이미지 애니메이션
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
                //타이머 스도오오옵
                gameTimer.invalidate()
                itemTimer.invalidate()
                //봉쓰 확대뷰 나오게... 다시 게임뷰로 돌아오는건 봉쓰확대뷰에서 해야함.
                let fireVC = FirebongViewController()
                fireVC.modalPresentationStyle = .overCurrentContext
                present(fireVC, animated: false)
                //다시 타이머 시작
                reStartTimer()
            default:
                break
            }
        } else {
            score -= 100
        }
    }
    
}

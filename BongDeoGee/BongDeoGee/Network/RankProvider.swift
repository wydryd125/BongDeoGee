//
//  RankProvider.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation
import Firebase

class RankProvier {
        
    // 정보를 저장해얌
    class func update(data: RankModel, completion: @escaping () -> ()) {
        Firestore
            .firestore()
            .collection("Rank")
            .addDocument(data: [
                RankReference.level: data.level,
                RankReference.name: data.name,
                RankReference.score: data.score
            ]) { (error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                    
                } else {
                    completion()
                }
        }
    }
    
    // 정보를 가저염
    class func fetch(completion: @escaping ([RankModel]) -> ()) {
        Firestore
            .firestore()
            .collection("Rank")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                    
                } else {
                    guard let documents = snapshot?.documents else { return }

                    var rankData = [RankModel]()
                    
                    for document in documents {
                        let data = document.data()
                        
                        guard
                            let level = data[RankReference.level] as? Int,
                            let name = data[RankReference.name] as? String,
                            let score = data[RankReference.score] as? Int
                            else { return }
                        
                        let tempRank = RankModel(name: name, level: level, score: score)
                        rankData.append(tempRank)
                    }
                    
                    completion(rankData)
                }
        }
    }
    
}

class Temp {
    
    let name = "업스2"
    let level = 0
    let score = 100000
    
    func buttonAction() {
        let myRank = RankModel(name: name, level: level, score: score)
        
        RankProvier.update(data: myRank) {
            print("Update!!!!")
        }
    }
    
    let tableview = UITableView()
    var tempData = [RankModel]()
    func rankFetch() {
        RankProvier.fetch { (rankData) in
            dump(rankData)
            self.tempData = rankData
            self.tableview.reloadData()
        }
    }
    
}

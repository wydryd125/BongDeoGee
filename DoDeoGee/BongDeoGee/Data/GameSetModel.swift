//
//  GameSetModel.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import UIKit

enum GameSet {
    case level1
    case level2
    case level3
    
    var interval: Double {
        switch self {
        case .level1:   return 0.8
        case .level2:   return 0.65
        case .level3:   return 0.5
        }
    }
    
    var toString: String {
        switch self {
        case .level1:   return "Level 1"
        case .level2:   return "Level 2"
        case .level3:   return "Level 3"
        }
    }
} 

class SaveRank {
    
    class func addKeys(name: String) {
        guard var keys = UserDefaults.standard.object(forKey: "keys") as? [String] else { return }
        guard !keys.contains(name) else { return }
        keys.append(name)
        
    }
    
    class func getKeys() -> [String] {
        UserDefaults.standard.object(forKey: "keys") as? [String] ?? [String]()
    }
    
    
    
    
    class func set(name: String, level: Int, score: Int) {
        let key = name + String(level)
        UserDefaults.standard.set(score, forKey: key) // 업스3
    }
    
    class func get(name: String, level: Int) -> Int {
        let key = name + String(level)
        
        return UserDefaults.standard.integer(forKey: key)
    }
}

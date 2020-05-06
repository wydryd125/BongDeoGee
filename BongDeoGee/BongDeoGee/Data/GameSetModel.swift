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
}

//
//  RankModel.swift
//  BongDeoGee
//
//  Created by 박지승 on 2020/02/06.
//  Copyright © 2020 Jisng. All rights reserved.
//

import Foundation

struct RankModel {
    let name: String
    let level: Int
    let score: Int
}

struct RankReference {
    static let name = "name"
    static let level = "level"
    static let score = "score"
}

//
//  IdentifiedBlock.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/18.
//

import Foundation

struct IdentifiedBlock : Block {
    var id: Int
    var number: Int
    init(id: Int, number: Int) {
        self.id = id
        self.number = number
    }
}

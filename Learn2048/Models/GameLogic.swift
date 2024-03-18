//
//  GameLogic.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/19.
//

import Foundation
import SwiftUI
import Combine

final class GameLogic : ObservableObject {
    enum Direction {
        case left
        case right
        case up
        case down
    }
    
    typealias BlockMatrixType = BlockMatrix<IdentifiedBlock>
    
    fileprivate var _blockMatrix: BlockMatrixType!
    
    let objectWillChange = PassthroughSubject<GameLogic, Never>()
    
    var blockMatrix: BlockMatrixType {
        return _blockMatrix
    }
    
    init() {
        self.newGame()
    }
    
    func newGame() {
        _blockMatrix = BlockMatrixType()
        _globalID = _blockMatrix.initBlockState()
        generateNewBlocks(newCount: 2)
        objectWillChange.send(self)
    }
    
    fileprivate var _globalID = 0
    fileprivate var newGlobalID: Int {
        _globalID += 1
        return _globalID
    }
    
    func move(_ dircection: Direction) {
        defer {
            objectWillChange.send(self)
        }
        
        var hasMove = false
        
        let axis = dircection == .left || dircection == .right
        let needReverse = dircection == .right || dircection == .down
        
        for row in (0..<4) {
            var oringalRow = [IdentifiedBlock?]()
            var solveRow = [IdentifiedBlock]()
            for col in (0..<4) {
                if let block = blockMatrix[axis ? (row, col) : (col, row)] {
                    oringalRow.append(block)
                    solveRow.append(block)
                }
                else {
                    oringalRow.append(nil)
                }
            }
            
            merge(solveRow: &solveRow, needReverse: needReverse)
            
            var newRow = [IdentifiedBlock?]()
            solveRow.forEach({ newRow.append($0) })
            if newRow.count < 4 {
                for _ in (0..<(4 - newRow.count)) {
                    if (needReverse) {
                        newRow.insert(nil, at: 0)
                    } else {
                        newRow.append(nil)
                    }
                }
            }
            
            newRow.enumerated().forEach({
                if $1?.number != oringalRow[$0]?.number {
                    hasMove = true
                }
                _blockMatrix.place($1, to: axis ? (row, $0) : ($0, row))
            })
        }
        
        if (hasMove) {
            self.generateNewBlocks()
        }
    }
    
    fileprivate func merge(solveRow: inout [IdentifiedBlock], needReverse: Bool) {
        if (needReverse) {
            solveRow.reverse()
        }
        solveRow = solveRow
            .map( { (false, $0) } )
            .reduce([(Bool, IdentifiedBlock)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    var nextAcc = acc
                    nextAcc.popLast()
                    var addBlock = item.1
                    addBlock.number *= 2
                    nextAcc.append((true, addBlock))
                    return nextAcc
                    
                } else {
                    var nextAcc = acc
                    nextAcc.append((false, item.1))
                    return nextAcc
                }
            }
            .map( { $0.1 } )
        if (needReverse) {
            solveRow.reverse()
        }
    }
    
    @discardableResult fileprivate func generateNewBlocks(newCount: Int = 1) -> Bool {
        var blankLocations = [BlockMatrixType.Index]()
        for row in 0..<4 {
            for col in 0..<4 {
                let idx = (row, col)
                if _blockMatrix[idx]?.number == 0 {
                    blankLocations.append(idx)
                }
            }
        }
        guard blankLocations.count >= newCount else {
            return false
        }
        
        defer {
            objectWillChange.send(self)
        }
        
        for _ in (0..<newCount) {
            let placeLocIndex = Int.random(in: 0..<blankLocations.count)
            _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: 2), to: blankLocations[placeLocIndex])
            blankLocations.remove(at: placeLocIndex)
        }
        return true
    }
}

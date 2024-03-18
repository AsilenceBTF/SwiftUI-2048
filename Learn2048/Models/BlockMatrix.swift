//
//  BlockMatrix.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/18.
//

import Foundation


protocol Block {
    var number: Int { get set }
    var id: Int { get set }
    init(id: Int, number: Int)
}

struct IndexedBlock<T> {
    let index: (Int, Int)
    let item: T?
}

struct BlockMatrix<T> where T : Block {
    
    typealias Index = (Int, Int)
    
    fileprivate var matrix: [[T?]]
    
    init() {
        self.matrix = [[T?]]()
    }
    
    mutating func initBlockState() -> Int {
        var id = 1
        for _ in 0..<4 {
            var row = [T?]()
            for _ in 0..<4 {
                row.append(T(id: id+1, number: 0))
                id += 1
            }
            self.matrix.append(row)
        }
        return id
    }
    
    var flatten: [IndexedBlock<T>] {
        return self.matrix.enumerated().flatMap { (y: Int, element: [T?]) in
            element.enumerated().map { (x: Int, element: T?) in
                return IndexedBlock(index: (x, y), item: element)
            }
        }
    }
    
    subscript(index: Index) -> T? {
        guard isIndexVaild(index) else {
            return nil
        }
        return matrix[index.0][index.1]
    }
    
    fileprivate func isIndexVaild(_ index: Index) -> Bool {
        guard index.0 >= 0 && index.0 < 4 else {
            return false
        }
        guard index.1 >= 0 && index.1 < 4 else {
            return false
        }
        return true
    }
    
    mutating func place(_ block: T?, to: Index) {
        self.matrix[to.0][to.1] = block
    }
}

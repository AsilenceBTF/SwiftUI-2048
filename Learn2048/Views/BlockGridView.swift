//
//  BlockGridView.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/18.
//

import Foundation
import SwiftUI


extension AnyTransition {
    
    static func blockAppear(from: Edge) -> AnyTransition {
        return .asymmetric(
            insertion: AnyTransition.opacity
                .combined(with: .move(edge: from)),
            removal: .identity)
    }
    
}

fileprivate struct IdentifiableIndexedBlock : Identifiable {
    
    typealias ID = String
    typealias IdentifiedValue = IndexedBlock<IdentifiedBlock>
    
    static var uniqueBlankId = 0
    
    let indexedBlock: IndexedBlock<IdentifiedBlock>
    
    var id: Self.ID {
        if let id = indexedBlock.item?.id {
            return "\(id)"
        }
        
        // TODO: (Refactor) Don't mix two types of block views.
        IdentifiableIndexedBlock.uniqueBlankId += 1
        return "Blank_\(IdentifiableIndexedBlock.uniqueBlankId)"
    }
    
    var identifiedValue: Self.IdentifiedValue {
        return indexedBlock
    }
}

struct BlockGridView : View {
    
    typealias SupportingMatrix = BlockMatrix<IdentifiedBlock>
    
    var matrix: SupportingMatrix
    let blockEnterEdge: Edge
    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height
    
    func createBlock(_ block: IdentifiedBlock?) -> some View {
        if let block = block {
            return BlockView(number: block.number)
        }
        return BlockView.blank()
    }
    
    var body: some View {
        ZStack {
            ForEach(
                matrix.flatten.map { block in
                    return IdentifiableIndexedBlock(indexedBlock: block)
                }
            ) { block in
                if block.identifiedValue.item != nil {
                    self.createBlock(block.identifiedValue.item).frame(width: 65, height: 65, alignment: .center)
                        .position(x: CGFloat(block.identifiedValue.index.0) * (65 + 12) + 32.5 + 12,
                                  y: CGFloat(block.identifiedValue.index.1) * (65 + 12) + 32.5 + 12)
                        .transition(AnyTransition.blockAppear(from: self.blockEnterEdge))
                        .animation(.spring)
                } else {
                    self.createBlock(block.identifiedValue.item).frame(width: 65, height: 65, alignment: .center)
                        .position(x: CGFloat(block.identifiedValue.index.0) * (65 + 12) + 32.5 + 12,
                                  y: CGFloat(block.identifiedValue.index.1) * (65 + 12) + 32.5 + 12)
                        .transition(AnyTransition.blockAppear(from: self.blockEnterEdge))
                }
            }
        }
        .frame(width: min(maxWidth, maxHeight) * 0.85, height: min(maxWidth, maxHeight) * 0.85, alignment: .center)
        .background(
            Rectangle()
                .fill(Color(red:0.72, green:0.66, blue:0.63, opacity:1.00))
        )
    }
}

struct preview_BlockGridView : PreviewProvider {
    static var matrix: BlockGridView.SupportingMatrix {
        var _matrix = BlockGridView.SupportingMatrix()
        _matrix.initBlockState()
        _matrix.place(IdentifiedBlock(id: 1, number: 2), to: (2, 0))
        _matrix.place(IdentifiedBlock(id: 2, number: 2), to: (3, 0))
        _matrix.place(IdentifiedBlock(id: 3, number: 8), to: (1, 1))
        _matrix.place(IdentifiedBlock(id: 4, number: 4), to: (2, 1))
        _matrix.place(IdentifiedBlock(id: 5, number: 512), to: (3, 3))
        _matrix.place(IdentifiedBlock(id: 6, number: 1024), to: (2, 3))
        _matrix.place(IdentifiedBlock(id: 7, number: 16), to: (0, 3))
        _matrix.place(IdentifiedBlock(id: 8, number: 8), to: (1, 3))
        return _matrix
    }
    static var previews: some View {
        BlockGridView(matrix: matrix, blockEnterEdge: .bottom)
    }
}

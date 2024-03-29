//
//  BlockView.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/16.
//

import Foundation
import SwiftUI

struct BlockView : View {
    
    fileprivate let colorScheme: [(Color, Color)] = [
        // 2
        (Color(red:0.91, green:0.87, blue:0.83, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
        // 4
        (Color(red:0.90, green:0.86, blue:0.76, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
        // 8
        (Color(red:0.93, green:0.67, blue:0.46, opacity:1.00), Color.white),
        // 16
        (Color(red:0.94, green:0.57, blue:0.38, opacity:1.00), Color.white),
        // 32
        (Color(red:0.95, green:0.46, blue:0.33, opacity:1.00), Color.white),
        // 64
        (Color(red:0.94, green:0.35, blue:0.23, opacity:1.00), Color.white),
        // 128
        (Color(red:0.91, green:0.78, blue:0.43, opacity:1.00), Color.white),
        // 256
        (Color(red:0.91, green:0.78, blue:0.37, opacity:1.00), Color.white),
        // 512
        (Color(red:0.90, green:0.77, blue:0.31, opacity:1.00), Color.white),
        // 1024
        (Color(red:0.91, green:0.75, blue:0.24, opacity:1.00), Color.white),
        // 2048
        (Color(red:0.91, green:0.74, blue:0.18, opacity:1.00), Color.white),
    ]
    
    fileprivate let number: Int?
    
    fileprivate init() {
        self.number = nil
    }
    
    init(number: Int?) {
        self.number = number
    }
    
    static func blank() -> Self {
        return self.init()
    }
    
    fileprivate var numberText: String {
        guard let number = self.number else {
            return ""
        }
        if number == 0 {
            return ""
        }
        return String(number)
    }
    
    fileprivate var fontSize: CGFloat {
        let textLenght = numberText.count
        if textLenght < 3 {
            return 32
        } else if textLenght < 4 {
            return 18
        } else {
            return 12
        }
    }
    
    fileprivate var colorPair: (Color, Color) {
        guard let number = self.number else {
            return (Color(red:0.78, green:0.73, blue:0.68, opacity:1.00), Color.black)
        }
        if number == 0 {
            return (Color(red:0.78, green:0.73, blue:0.68, opacity:1.00), Color.black)
        }
        let index = Int(log2(Double(number))) - 1
        if index < 0 || index >= colorScheme.count {
            fatalError("No color for such number")
        }
        return colorScheme[index]
    }
    var body: some View {
        ZStack {
            Rectangle().fill(colorPair.0)
            Text(numberText)
                .font(Font.system(size: fontSize).bold())
                .foregroundColor(colorPair.1)
                .id(numberText)
//                .transition(AnyTransition.scale(scale: 0.5, anchor: .center).combined(with: .opacity))
        }
        .cornerRadius(6)
//        .clipped()
    }
}

#Preview {
    Group {
        BlockView.blank()
            .previewLayout(.sizeThatFits)
        ForEach((1...11).map { value in
            return Int(pow(2.0, Double(value)))
        }, id: \.self) { i in
            BlockView(number: i)
                .frame(width: 65, height: 65, alignment: .center)
                .previewLayout(.sizeThatFits)
        }
    }
}

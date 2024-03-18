//
//  ContentView.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/15.
//

import SwiftUI


extension Edge {
    
    static func from(_ from: GameLogic.Direction) -> Self {
        switch from {
        case .down:
            return .top
        case .up:
            return .bottom
        case .left:
            return .trailing
        case .right:
            return .leading
        }
    }
    
}


struct GameView: View {
    
    @EnvironmentObject var gameLogic: GameLogic
    @State var gestureStartLocation: CGPoint = .zero
    @State var lastGestureDirection: GameLogic.Direction = .up
    
    var gesture: some Gesture {
        let threshold: CGFloat = 44
        let drag = DragGesture()
            .onChanged { v in
                guard self.gestureStartLocation != v.startLocation else { return }
                withTransaction(Transaction()) {
                    self.gestureStartLocation = v.startLocation
                    if v.translation.width > threshold {
                        // Move right
                        self.gameLogic.move(.right)
                        lastGestureDirection = .right
                        print("Move right")
                    } else if v.translation.width < -threshold {
                        // Move left
                        self.gameLogic.move(.left)
                        lastGestureDirection = .left
                        print("Move left")
                    } else if v.translation.height > threshold {
                        // Move down
                        self.gameLogic.move(.down)
                        lastGestureDirection = .down
                        print("Move down")
                    } else if v.translation.height < -threshold {
                        // Move up
                        self.gameLogic.move(.up)
                        lastGestureDirection = .up
                        print("Move up")
                    } else {
                        // Direction cannot be deduced, reset gesture state.
                        self.gestureStartLocation = .zero
                    }
                }
                
                OperationQueue.main.addOperation {
                    self.lastGestureDirection = .up
                }
                // After the scene is updated, reset the last gesture direction
                // to make sure the animation is right when user starts a new
                // game.
            }
        return drag
    }
    
    var body: some View {
        ZStack {
            Button(action: {
                self.gameLogic.newGame()
            }) {
                HStack {
                    Text("Reset")
                    Image(systemName: "goforward")
                }
            }.position(x:185, y:30)
            Text("2048")
                .font(Font.system(size: 48).weight(.black))
                .foregroundColor(Color(red:0.47, green:0.43, blue:0.40, opacity:1.00))
            ZStack {
                BlockGridView(matrix:self.gameLogic.blockMatrix, blockEnterEdge: .from(self.lastGestureDirection))
                    .gesture(self.gesture)
            }
        }
    }
}

#Preview {
    GameView().environmentObject(GameLogic())
}

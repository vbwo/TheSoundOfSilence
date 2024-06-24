//
//  MiniGameDoor.swift
//  TSOS
//
//  Created by Juliana Neves de Mesquita Rodrigues dos Santos on 22/06/24.
//

import SwiftUI

import SwiftUI

struct MiniGameDoorView: View {
    @State private var arrowPosition: CGFloat = 0.5
    @State private var isAnimating = false
    @State private var movingUp = true
    @State private var timer: Timer?
    @State private var errorCount = 0
    @State private var showJumpScare = false
    
    var body: some View {
        VStack {
            if showJumpScare {
                Image("jumpSkeleton")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    
            } else {
                VStack (alignment: .center, spacing: 24.0) {
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.red, .orange, .yellow, .green, .yellow, .orange, .red]),
                                startPoint: .leading,
                                endPoint: .trailing))
                            .frame(width: 300, height: 50)
                        
                        ZStack {
                            ArrowShape2()
                                .stroke(Color.white, lineWidth: 5)
                                .frame(width: 20, height: 20)
                            ArrowShape2()
                                .fill(Color.redArrow)
                                .frame(width: 20, height: 20)
                        }
                        .offset(x: (arrowPosition - 0.5) * 300)
                        .offset(y: 35)
                    }
                    .padding()
                    
                    Button(action: {
                        stopAnimation()
                        checkPosition()
                    }) {
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.gray, .white, .gray]),
                                    startPoint: .leading,
                                    endPoint: .trailing))
                                .frame(width: 193, height: 52)
                            
                            Text("Segure a porta")
                                .foregroundStyle(.black)
                                .font(.custom("Dark Distance", size: 18))
                        }
                    }
                }
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    func startAnimation() {
        isAnimating = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.007, repeats: true) { _ in
            withAnimation(.linear(duration: 0.01)) {
                if movingUp {
                    arrowPosition -= 0.01
                    if arrowPosition < 0.0 {
                        arrowPosition = 0.0
                        movingUp = false
                    }
                } else {
                    arrowPosition += 0.01
                    if arrowPosition > 1.0 {
                        arrowPosition = 1.0
                        movingUp = true
                    }
                }
            }
        }
    }
    
    func stopAnimation() {
        isAnimating = false
        timer?.invalidate()
        timer = nil
    }
    
    func checkPosition() {
        let greenZoneStart: CGFloat = 0.35
                let greenZoneEnd: CGFloat = 0.65
                
                if arrowPosition >= greenZoneStart && arrowPosition <= greenZoneEnd {
                    print("Acertou!")
        } else {
            errorCount += 1
            if errorCount >= 3 {
                showJumpScare = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    resetGame()
                }
            } else {
                arrowPosition = 0.5
                startAnimation()
            }
        }
    }
    
    func resetGame() {
        showJumpScare = false
        errorCount = 0
        arrowPosition = 0.5
        movingUp = true
        startAnimation()
    }
}

struct ArrowShape2: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


#Preview {
    MiniGameDoorView()
}

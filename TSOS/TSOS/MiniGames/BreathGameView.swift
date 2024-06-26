//
//  GameBreath.swift
//  TSOS
//
//  Created by Diego Ferreira Santos on 19/06/24.
//

import SwiftUI
import CoreHaptics
import AVKit

struct BreathGameView: View {
    
    @State private var isButtonVisible = true
    @State private var showGlitchVideo = false
    @State private var showGameOverImage = false
    @State private var circleSize: CGFloat = 150
    @State private var isPressed = false
    @State private var isSuccess = false
    @State private var isFailed = false
    @State private var timer: Timer?
    @State private var timerSuc: Timer?
    @State private var player: AVPlayer?
    
    var tempoRestante = 5
    let timerSuccess = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let minSize: CGFloat = 50
    let maxSize: CGFloat = 200
    let interval: TimeInterval = 0.1
    let growthRate: CGFloat = 10
    let img: String
    let updateBackgroundImage: (String) -> Void
    var goToNextScene: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if showGameOverImage {
                    VStack {
                        ZStack {
                            Image("gameover")
                                .offset(y: -67)
                                .ignoresSafeArea()
                                .transition(.opacity)
                            
                            Button(action: {
                                resetGame()
                            }) {
                                Text("TENTAR\nNOVAMENTE ")
                                    .foregroundStyle(.white)
                                    .font(.custom("Dark Distance", size: 32))
                                    .multilineTextAlignment(.center)
                                    .shadow(radius: 10)
                            }
                            .offset(y: 220)
                        }
                    }
                } else if showGlitchVideo, let player = player {
                    GlitchVideoView(player: player, size: geometry.size)
                        .edgesIgnoringSafeArea(.all)
                        .ignoresSafeArea(.all)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + (player.currentItem?.duration.seconds ?? 0)) {
                                withAnimation(.easeOut(duration: 2)) {
                                    showGameOverImage = true
                                }
                            }
                        }
                } else {                    
                    Spacer()
                    VStack {
                        HStack {
                            Text("Controle sua respiração pressionando o círculo para regulá-lo. Não o deixe tão grande ou tão pequeno.")
                                .font(Font.custom("Press Start 2P", size: 10))
                                .lineSpacing(4)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 302, alignment: .top)
                        }
                        .foregroundColor(.clear)
                        .frame(width: 331, height: 86)
                        .background(.black.opacity(0.75))
                        .overlay(
                            Rectangle()
                                .inset(by: 1.5)
                                .stroke(.white, lineWidth: 3)
                        )
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(circleColor)
                                .frame(width: circleSize, height: circleSize)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            self.isPressed = true
                                        }
                                        .onEnded { _ in
                                            self.isPressed = false
                                        }
                                )
                                .animation(.linear, value: circleSize)
                            
                            if isButtonVisible {
                                Button(action: {
                                    isButtonVisible = false
                                    startGame()
                                }) {
                                    HStack {
                                        Text("INICIAR ")
                                            .font(Font.custom("Dark Distance", size: 24))
                                            .foregroundColor(.black)
                                    }
                                    .foregroundColor(.clear)
                                }
                            } else {
                                Button(action: {}) {
                                    Text("Click me to disappear")
                                        .padding()
                                        .background(Color.clear)
                                        .foregroundColor(.clear)
                                        .cornerRadius(10)
                                }
                                .hidden()
                            }
                        }
                        
                    } .frame(width: 393, height: 320)
                        
                    Spacer()
                }
            }
            .onAppear {
                updateBackgroundImage(img)
                prepareGlitchVideo()
            }
        }
    }
    
    var circleColor: Color {
        if isFailed {
            return Color.red
        } else if circleSize > 160 || circleSize < 130 {
            return Color.red
        } else {
            return Color(red: 228, green: 228, blue: 228)
        }
    }
    
    func prepareGlitchVideo() {
        if let url = Bundle.main.url(forResource: "glitch", withExtension: "mov") {
            player = AVPlayer(url: url)
        }
    }
    
    func startGame() {
        isSuccess = false
        isFailed = false
        circleSize = 150
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if self.isPressed {
                self.circleSize += self.growthRate
            } else {
                self.circleSize -= self.growthRate
            }
            
            if self.circleSize <= self.minSize || self.circleSize >= self.maxSize {
                self.isFailed = true
                self.stopTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 2)) {
                        showGlitchVideo = true
                    }
                }
            }
        }
        
        timerSuc = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
            self.isSuccess = true
            self.stopTimer()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                goToNextScene()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerSuc?.invalidate()
        timerSuc = nil
    }
    
    func resetGame() {
        isButtonVisible = true
        showGlitchVideo = false
        showGameOverImage = false
        circleSize = 150
        isPressed = false
        isSuccess = false
        isFailed = false
        stopTimer()
    }
}

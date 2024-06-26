//
//  MiniGameDoor.swift
//  TSOS
//
//  Created by Juliana Neves de Mesquita Rodrigues dos Santos on 22/06/24.
//

import SwiftUI
import CoreHaptics
import AVKit

struct GlitchVideoView: View {
    var player: AVPlayer
    var size: CGSize
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
            .scaleEffect(CGSize(width: 1.2, height: 1.2))
    }
}

struct DoorGameView: View {
    @State private var arrowPosition: CGFloat = 0.5
    @State private var isAnimating = false
    @State private var movingUp = true
    @State private var timer: Timer?
    @State private var errorCount = 0
    @State private var successCount = 0
    @State private var showJumpScare = false
    @State private var engine: CHHapticEngine?
    @State private var shakeOffset: CGFloat = 0
    @State private var showGlitchVideo = false
    @State private var showGameOverImage = false
    @State private var player: AVPlayer?
    let img: String
    let updateBackgroundImage: (String) -> Void
    var goToNextScene: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if showGameOverImage {
                    Image("gameover")
                        .ignoresSafeArea()
                        .transition(.opacity)
                } else if showGlitchVideo, let player = player {
                    GlitchVideoView(player: player, size: geometry.size)
                        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
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
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.75))
                                .frame(width: 311, height: 70, alignment: .leading)
                                .border(Color.white, width: 3)
                            Text("Aperte o botão quando a\nseta chegar ao verde para\nsegurar a porta.")
                                .font(Font.custom("PressStart2P-Regular", size: 10))
                                .foregroundColor(.white)
                                .lineSpacing(5)
                                .multilineTextAlignment(.center)
                            
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Rectangle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.red, .orange, .yellow, .green, .yellow, .orange, .red]),
                                    startPoint: .leading,
                                    endPoint: .trailing))
                                .frame(width: 300, height: 50)
                                .border(Color.white, width: 3)
                            
                            ZStack {
                                ArrowShape2()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 20, height: 20)
                                    .cornerRadius(4)
                                ArrowShape2()
                                    .fill(Color.redArrow)
                                    .frame(width: 16, height: 16)
                                    .cornerRadius(4)
                            }
                            .offset(x: (arrowPosition - 0.5) * 300)
                            .offset(y: 25)
                        }
                        .padding()
                        
                        Spacer()
                        
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
                                
                                Text("SEGURE A PORTA ")
                                    .foregroundStyle(.black)
                                    .font(.custom("Dark Distance", size: 18))
                            }
                        } .padding(.top, -8)
                        
                        Spacer()
                        
                        Text("\(successCount)/3")
                            .font(Font.custom("PressStart2P-Regular", size: 24))
                            .foregroundColor(.white)
                           
                        
                    } .frame(width: 327, height: 401)
                        .padding(.leading, 36)
                    
                    Spacer()
                }
            } .offset(x: shakeOffset)
                .onAppear {
                    startAnimation()
                    updateBackgroundImage(img)
                    prepareGlitchVideo()
                }
        }
    }
    
    
    //MARK: Functions
    
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
            successCount += 1
            if successCount >= 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    goToNextScene()
                }
            } else {
                arrowPosition = 0.5
                startAnimation()
            }
        } else {
            errorCount += 1
            if errorCount >= 3 {
                withAnimation(.easeOut(duration: 1)) {
                    showGlitchVideo = true
                }
            } else {
                arrowPosition = 0.5
                startAnimation()
                prepareHaptics()
                wrongHaptics()
                shakeScreen()
            }
        }
    }
    
    func resetGame() {
        showJumpScare = false
        errorCount = 0
        successCount = 0
        arrowPosition = 0.5
        movingUp = true
        startAnimation()
    }
    
    func prepareGlitchVideo() {
        if let url = Bundle.main.url(forResource: "glitch", withExtension: "mov") {
            player = AVPlayer(url: url)
        }
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Start Error: \(error.localizedDescription)")
        }
    }
    
    func wrongHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
        
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        let pause = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.12)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.19, duration: 0.1)
        
        events.append(event1)
        events.append(pause)
        events.append(event2)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
        
    }
    
    func shakeScreen() {
        let shakeAnimation = Animation.linear(duration: 0.02).repeatCount(10, autoreverses: true)
        withAnimation(shakeAnimation) {
            shakeOffset = 10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(Animation.linear(duration: 0.02)) {
                shakeOffset = 0
            }
        }
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

import SwiftUI
import CoreHaptics

struct ScreamGameView: View {
    @State private var arrowPosition: CGFloat = 0.5
    @State private var isAnimating = false
    @State private var movingUp = true
    @State private var timer: Timer?
    @State private var errorCount = 0
    @State private var showJumpScare = false
    @State private var engine: CHHapticEngine?
    let img: String
    let updateBackgroundImage: (String) -> Void
    var goToNextScene: () -> Void
    
    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 311, height: 71, alignment: .leading)
                    .border(Color.white, width: 3)
                Text("Pressione o botão abaixo\nquando a seta atingir o\nverde para poder gritar!")
                    .font(Font.custom("PressStart2P-Regular", size: 10))
                    .foregroundColor(.white)
                    .lineSpacing(5)
                    .multilineTextAlignment(.center)
                
            }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
                        startPoint: .top,
                        endPoint: .bottom))
                    .frame(width: 50, height: 300)
                    .border(Color.white, width: 3)
                    .zIndex(1)
                
                ZStack {
                    ArrowShape()
                        .stroke(Color.white, lineWidth: 4)
                        .frame(width: 20, height: 20)
                        .cornerRadius(4)
                    ArrowShape()
                        .fill(Color.red)
                        .frame(width: 16, height: 16)
                        .cornerRadius(4)
                }
                .offset(y: (arrowPosition - 0.5) * 300)
                .offset(x: -25)
                .zIndex(2)
            }
            
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
                    
                    Text("GRITAR ")
                        .foregroundStyle(.black)
                        .font(.custom("Dark Distance", size: 24))
                }
            } .padding(.top, 8)
            
            Spacer()
            
        } .frame(width: 311, height: 560)
            .padding(.bottom, 88)
            .onAppear {
                startAnimation()
                updateBackgroundImage(img)
                
            }
    }
    
    //MARK: Functions
    
    func startAnimation() {
        isAnimating = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true) { _ in
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
        if arrowPosition <= 0.25 {
            goToNextScene()
        } else {
            arrowPosition = 0.5
            startAnimation()
            prepareHaptics()
            wrongHaptics()
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
}

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}



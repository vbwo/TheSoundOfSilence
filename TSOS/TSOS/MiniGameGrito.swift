import SwiftUI

struct MiniGameView: View {
    @State private var arrowPosition: CGFloat = 0.5
    @State private var isAnimating = false
    @State private var movingUp = true
    @State private var timer: Timer?
    @State private var errorCount = 0
    @State private var showJumpScare = false
    
    var body: some View {
        VStack {
            if showJumpScare {
                // Jump scare view
                Image("jumpGrito")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    
            } else {
                ZStack {
                    // Barra com degradê
                    Rectangle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.green, .yellow, .orange, .red]),
                            startPoint: .top,
                            endPoint: .bottom))
                        .frame(width: 50, height: 300)
                    
                    // Seta que se move com contorno
                    ZStack {
                        ArrowShape()
                            .stroke(Color.white, lineWidth: 5)
                            .frame(width: 20, height: 20)
                        ArrowShape()
                            .fill(Color.redArrow)
                            .frame(width: 20, height: 20)
                    }
                    .offset(y: (arrowPosition - 0.5) * 300) // Ajustar posição da seta
                    .offset(x: -35) // Colocar a seta à esquerda da barra
                }
                .padding()
                
                // Botão para parar a seta
                Button(action: {
                    stopAnimation()
                    checkPosition()
                }) {
                    ZStack {
                        // Barra com degradê
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.gray, .white, .gray]),
                                startPoint: .leading,
                                endPoint: .trailing))
                            .frame(width: 193, height: 52)
                        
                        Text("Gritar")
                            .foregroundStyle(.black)
                            .font(.custom("Dark Distance", size: 24))
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
        // Verifica se a seta parou na zona verde (assumindo que a zona verde é a primeira 1/4 parte da barra)
        if arrowPosition <= 0.25 {
            // Acertou, continuar o jogo
            print("Acertou!")
        } else {
            // Errou
            errorCount += 1
            if errorCount >= 2 {
                // Mostra o jumpscare
                showJumpScare = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    resetGame()
                }
            } else {
                // Reinicia o minigame após o primeiro erro
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


#Preview {
    MiniGameView()
}

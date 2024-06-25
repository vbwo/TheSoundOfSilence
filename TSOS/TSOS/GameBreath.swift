//
//  GameBreath.swift
//  TSOS
//
//  Created by Diego Ferreira Santos on 19/06/24.
//

import SwiftUI

struct CircleGameView: View {
    
    @State private var isButtonVisible = true
    @State private var mostrarJumpOver = false
    
    @State private var circleSize: CGFloat = 150 // Tamanho inicial do círculo
    @State private var isPressed = false
    @State private var isSuccess = false
    @State private var isFailed = false
    @State private var timer: Timer?
    @State private var timerSuc: Timer?
    
    var tempoRestante = 5
    let timerSuccess = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


    // Defina os tamanhos mínimo e máximo para o círculo
    let minSize: CGFloat = 80
    let maxSize: CGFloat = 200
    // Intervalo de tempo para atualização
    let interval: TimeInterval = 0.1
    // Taxa de crescimento e diminuição
    let growthRate: CGFloat = 10

    var body: some View {
        
        ZStack {
            Image("BreathGame")
            
            VStack {
                Spacer()
                    .frame(maxHeight: 148)
                
                HStack{
                    
                    Text("Controle sua respiração. Não deixe o circulo ficar muito grande ou muito pequeno.")
                      .font(Font.custom("Press Start 2P", size: 10))
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
                    .frame(maxHeight: 150)
                    
                
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
                
                Spacer()
                    .frame(maxHeight: 50)
                    
    //------------------  MUDAR PARA SUCESSO
                if isSuccess {
                    Text("Parabéns!")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                }
                
                
    //------------------ BOTÕES
                
                if isButtonVisible {
                    Button(action: {
                        isButtonVisible = false
                        self.startGame()
                    } , label: {
                        HStack {
                            Text("RESPIRE")
                              .font(Font.custom("Dark Distance", size: 20))
                              .foregroundColor(.black)
                        }
                        .foregroundColor(.clear)
                        .frame(width: 193, height: 47)
                        .background(
                        LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.56, green: 0.56, blue: 0.56), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.89, green: 0.89, blue: 0.89), location: 0.50),
                        Gradient.Stop(color: Color(red: 0.56, green: 0.56, blue: 0.56), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0.5),
                        endPoint: UnitPoint(x: 1, y: 0.5)
                        )
                        )
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    })
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
                
                if isFailed {
                    Spacer()
                        .frame(maxHeight: 20)
                    Button(action: {
                        isButtonVisible = false
                        self.startGame()
                    }, label: {
                        HStack {
                            Text("TENTAR DENOVO")
                              .font(Font.custom("Dark Distance", size: 20))
                              .foregroundColor(.black)
                        }
                        .foregroundColor(.clear)
                        .frame(width: 193, height: 47)
                        .background(
                        LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.56, green: 0.56, blue: 0.56), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.89, green: 0.89, blue: 0.89), location: 0.50),
                        Gradient.Stop(color: Color(red: 0.56, green: 0.56, blue: 0.56), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0, y: 0.5),
                        endPoint: UnitPoint(x: 1, y: 0.5)
                        )
                        )
                        .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    })
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
                
                Spacer()
                
            }
            
            
            
            
            GameOverTeste(showJumpOver: $mostrarJumpOver)
            
        }
        .ignoresSafeArea()
        
        
        
        
    }

    // Computed property para determinar a cor do círculo
    var circleColor: Color {
        if isFailed {
            return Color.red
        }; if circleSize > 160 || circleSize < 130 {
            return Color.red
            
        }else {
            return Color(red: 228, green: 228, blue: 228)
                
        }
    }

    func startGame() {
        mostrarJumpOver = false
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
                self.mostrarJumpOver = true
                self.stopTimer()
            }
            
        }
        
        timerSuc = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
            self.isSuccess = true
            self.stopTimer()
            
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerSuc?.invalidate()
        timerSuc = nil
    }
    
    func aparecerGameOver() {
        mostrarJumpOver = true
        
    }
    
    
    
}

struct CircleGameView_Previews: PreviewProvider {
    static var previews: some View {
        CircleGameView()
    }
}

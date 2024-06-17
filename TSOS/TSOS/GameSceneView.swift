//
//  GameSceneView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI

struct GameSceneView: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var showArrow: Bool = false
    @State private var arrowOffset: CGFloat = 0
    var sceneImage: String
    var fullText: String
  
    
    var body: some View {
        ZStack {
            Image(sceneImage)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.75))
                        .frame(width: 353, height: 128, alignment: .leading)
                        .border(Color.white, width: 3)
                    
                    VStack(alignment: .leading) {
                        Text(displayedText)
                            .font(Font.custom("PressStart2P-Regular", size: 10))
                            .foregroundColor(.white)
                            .padding(.leading, 16)
                            .padding(.top, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onAppear {
                                showText()
                            }
                        
                        Spacer()
                        
                        if showArrow {
                            Image(systemName: "arrowtriangle.right.fill")
                                .foregroundColor(.white)
                                .offset(x: arrowOffset)
                                .frame(height: 20)
                                .padding(.leading, 310)
                                .padding(.bottom, 12)
                                .onAppear {
                                    animateArrow()
                                }
                        }
                    }
                    .frame(width: 353, height: 128)
                }
                .padding(.bottom, 40)
                
            }
        } 
    }
    
    func showText() {
        displayedText = ""
        currentIndex = 0
        showArrow = false
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if currentIndex < fullText.count {
                let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
                displayedText.append(fullText[index])
                currentIndex += 1
            } else {
                timer.invalidate()
                showArrow = true
            }
        }
    }
    
    func animateArrow() {
        withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: true)) {
            arrowOffset = 10
        }
    }
}

#Preview {
    GameSceneView(sceneImage: "", fullText: "")
}

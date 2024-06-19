//
//  GameSceneView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI

enum SceneType {
    case dialogue(text: String, img: String)
    case walk(text: String, img: String, imgicon: String)
}

struct GameSceneView: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var showArrow: Bool = false
    @State private var arrowOffset: CGFloat = 0
    @State private var currentSceneIndex: Int = 0
    @State private var backgroundImg = ""
    
    let scenes: [SceneType]
    
    var body: some View {
        ZStack {
            Image(backgroundImg)
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                    switch scenes[currentSceneIndex] {
                    case .dialogue(let text, let img):
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.75))
                                .frame(width: 353, height: 128, alignment: .leading)
                                .border(Color.white, width: 3)
                                .onTapGesture {
                                    if showArrow {
                                        goToNextScene()
                                    }
                                }
                            VStack(alignment: .leading) {
                                Text(displayedText)
                                    .font(Font.custom("PressStart2P-Regular", size: 10))
                                    .foregroundColor(.white)
                                    .lineSpacing(8)
                                    .padding(.leading, 16)
                                    .padding(.top, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onAppear {
                                        showText(text)
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
                            } .onAppear {
                                backgroundImg = img
                            }
                            .frame(width: 353, height: 128)
                        } .padding(.bottom, 40)
                        
                    case .walk(let text, let img, let imgicon):
                        
                        VStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.black.opacity(0.75))
                                    .frame(width: 63, height: 63, alignment: .leading)
                                    .border(Color.white, width: 3)
                                Image(imgicon)
                                
                            } .onTapGesture {
                                goToNextScene()
                            }
                            
                            Text(text)
                                .font(Font.custom("PressStart2P-Regular", size: 10))
                                .foregroundColor(.white)
                                .padding(.top, 14)
                        } .padding(.bottom, 80)
                        .onAppear {
                            backgroundImg = img
                        }
                    }
                
            }
        }
    }
    
    func showText(_ text: String) {
        displayedText = ""
        currentIndex = 0
        showArrow = false
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if currentIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: currentIndex)
                displayedText.append(text[index])
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
    
    func goToNextScene() {
        if currentSceneIndex < scenes.count - 1 {
            currentSceneIndex += 1
            switch scenes[currentSceneIndex] {
            case .dialogue(let text, let img):
                showText(text)
                backgroundImg = img
            case .walk(let text, let img, _):
                showText(text)
                backgroundImg = img
            }
        }
    }
}

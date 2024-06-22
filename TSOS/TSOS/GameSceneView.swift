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
    case empty(img: String)
    case miniGames(gameType: MiniGameType)
    
    enum MiniGameType {
        case locker(img: String)
    }
}

struct GameSceneView: View {
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var showArrow: Bool = false
    @State private var arrowOffset: CGFloat = 0
    @State private var currentSceneIndex: Int = 0
    @State private var backgroundImg = ""
    @State private var isShowingText = false
    
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
                    DialogueScene(
                        text: text,
                        img: img,
                        displayedText: $displayedText,
                        showArrow: $showArrow,
                        arrowOffset: $arrowOffset,
                        isShowingText: $isShowingText,
                        showText: showText,
                        animateArrow: animateArrow,
                        goToNextScene: goToNextScene,
                        updateBackgroundImage: updateBackgroundImage
                    )
                    
                case .walk(let text, let img, let imgicon):
                    WalkScene(
                        text: text,
                        img: img,
                        imgicon: imgicon,
                        goToNextScene: goToNextScene,
                        updateBackgroundImage: updateBackgroundImage
                    )
                    
                case .empty(let img):
                    EmptyScene(
                        img: img,
                        goToNextScene: goToNextScene,
                        updateBackgroundImage: updateBackgroundImage
                    )
                    
                case .miniGames(let gameType):
                    switch gameType {
                    case .locker(let img):
                        LockerScene(
                            img: img,
                            updateBackgroundImage: updateBackgroundImage,
                            goToNextScene: goToNextScene
                        )
                    }
                }
            }
        }
    }
    
    //MARK: Functions
    
    func showText(_ text: String) {
        displayedText = ""
        currentIndex = 0
        showArrow = false
        isShowingText = true
        
        Timer.scheduledTimer(withTimeInterval: 0.04, repeats: true) { timer in
            if currentIndex < text.count {
                if !isShowingText {
                    displayedText = text
                    timer.invalidate()
                    showArrow = true
                } else {
                    let index = text.index(text.startIndex, offsetBy: currentIndex)
                    displayedText.append(text[index])
                    currentIndex += 1
                }
            } else {
                timer.invalidate()
                showArrow = true
                isShowingText = false
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
            let nextScene = scenes[currentSceneIndex]
            switch nextScene {
            case .dialogue(let text, let img):
                showText(text)
                updateBackgroundImage(img)
            case .walk(let text, let img, _):
                showText(text)
                updateBackgroundImage(img)
            case .empty(let img):
                updateBackgroundImage(img)
            case .miniGames(gameType: let gameType):
                switch gameType {
                case .locker(let img):
                    updateBackgroundImage(img)
                }
            }
        }
    }
    
    func updateBackgroundImage(_ img: String) {
        backgroundImg = img
    }
}

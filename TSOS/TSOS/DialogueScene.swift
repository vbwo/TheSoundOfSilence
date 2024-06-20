//
//  DialogueScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI

struct DialogueScene: View {
    let text: String
    let img: String
    @Binding var displayedText: String
    @Binding var showArrow: Bool
    @Binding var arrowOffset: CGFloat
    var showText: (String) -> Void
    var animateArrow: () -> Void
    var goToNextScene: () -> Void
    var updateBackgroundImage: (String) -> Void
    
    var body: some View {
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
            }
            .frame(width: 353, height: 128)
        }
        .padding(.bottom, 40)
        .onAppear {
            updateBackgroundImage(img)
        }
    }
}


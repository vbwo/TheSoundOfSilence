//
//  WalkScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI

struct WalkScene: View {
    let text: String
    let img: String
    let imgicon: String
    var goToNextScene: () -> Void
    var updateBackgroundImage: (String) -> Void
    
    var body: some View {
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
            updateBackgroundImage(img)
        }
    }
}

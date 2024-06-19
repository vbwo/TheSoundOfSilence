//
//  StartScreenView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI

struct StartScreenView: View {
    @Binding var isFadingOut: Bool
    var showNextView: () -> Void
    
    var body: some View {
        ZStack {
            
            Image("startscreen")
                .resizable()
            Rectangle()
                .foregroundStyle(.black)
                .opacity(0.5)
            
            
            VStack {
                
                Text("The Sound\nOf Silence")
                    .foregroundStyle(.white)
                    .font(.custom("horroroid", size: 80))
                
                Spacer()
                
                Button(action: {
                    showNextView()
                }) {
                    Text("INICIAR ")
                        .foregroundStyle(.white)
                        .font(.custom("Dark Distance", size: 44))
                        .shadow(radius: 10)
                }
                
            } .frame(width: 274, height: 523)
        } .ignoresSafeArea()
    }
}


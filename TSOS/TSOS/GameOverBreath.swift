//
//  GameOverTeste.swift
//  TSOS
//
//  Created by Diego Ferreira Santos on 20/06/24.
//

import SwiftUI

struct GameOverTeste: View {
    
    @Binding var showJumpOver : Bool
    
    var body: some View {
        ZStack {
            VStack{
                
            }
            if showJumpOver {
                Image("jump1")
                Color.black
                    .padding(.top, 0)
                    .ignoresSafeArea()
                    .opacity(0.3)
                    .onTapGesture {
                        showJumpOver = false
                        
                    }.onAppear(perform: showImage)
                
                
            }
            
        }
        
    }
    
    func showImage() {
           withAnimation {
               showJumpOver = true
           }
           hideImageAfterDelay()
       }

       func hideImageAfterDelay() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   showJumpOver = false
           }
       }
    
    
    }
    
    #Preview {
        CircleGameView()
    }


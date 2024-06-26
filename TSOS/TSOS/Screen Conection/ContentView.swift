//
//  ContentView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentView = 1
    @State private var isFadingOut = false
    
    var body: some View {
        ZStack {
            if currentView == 1 {
                StartScreenView(isFadingOut: $isFadingOut, showNextView: showNextView)
                    .opacity(isFadingOut ? 0 : 1)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1), value: isFadingOut)
            } else if currentView == 2 {
                WarningView()
                    .opacity(isFadingOut ? 0 : 1)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1), value: isFadingOut)
            } else if currentView == 3 {
                RecommendView()
                    .opacity(isFadingOut ? 0 : 1)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1), value: isFadingOut)
            } else if currentView == 4 {
                GamePlayView()
            }
        }
        .background(.black)
    }
    
    private func showNextView() {
        withAnimation {
            isFadingOut = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                currentView += 1
                isFadingOut = false
            }
            if currentView < 4 {
                transitionToNextView(after: 4)
            }
        }
    }
    
    private func transitionToNextView(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation {
                isFadingOut = true
            }
            showNextView()
        }
    }
}

#Preview {
    ContentView()
}


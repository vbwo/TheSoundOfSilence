//
//  EmptyScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 20/06/24.
//

import SwiftUI

struct EmptyScene: View {
    let img: String
    var goToNextScene: () -> Void
    var updateBackgroundImage: (String) -> Void
    
    var body: some View {
        VStack {
            Image(img)
                .ignoresSafeArea()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        goToNextScene()
                        updateBackgroundImage(img)
                    }
                }
                .onChange(of: img){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        goToNextScene()
                        updateBackgroundImage(img)
                    }
                }
        }
    }
}

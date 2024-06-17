//
//  ContentView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI


struct ContentView: View {
    
    
    var body: some View {
        VStack {
            GameSceneView(sceneImage: "station1", fullText: "Droga! Perdi o último metrô...")
        }
    }
}

#Preview {
    ContentView()
}

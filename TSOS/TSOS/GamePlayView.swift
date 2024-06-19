//
//  GamePlayView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI

struct GamePlayView: View {
    var body: some View {
        GameSceneView(scenes: [
            .dialogue(text: "Droga! Perdi o último metrô...", img: "station1"),
            .dialogue(text: "Agora já era. Vou sair daqui\ne tentar a sorte de passar um\ntáxi.", img: "station1"),
            .walk(text: "Andar", img: "station1", imgicon: "walkingleft"),
            .walk(text: "Sair", img: "exit1", imgicon: "walkingexit")
        ])
    }
}

#Preview { 
    GamePlayView()
}


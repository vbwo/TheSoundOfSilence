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
            .walk(text: "Sair", img: "exit1", imgicon: "walkingexit"),
            .miniGames(gameType: .locker(img: "exitlocked")),
            .dialogue(text: "Era só o que me faltava. Não\nencontro nenhuma saída aberta.", img: "exit1"),
            .dialogue(text: "Não é possível que estou presa.\nPreciso achar alguém para me\najudar a sair.", img: "exit1"),
            .walk(text: "Sair", img: "exit1", imgicon: "walkingright"),
            .empty(img: "lightsoff1")
        ])
    } 
}

#Preview { 
    GamePlayView()
}


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
            .walk(text: "Andar", img: "exit1", imgicon: "walkingright"),
            .empty(img: "station1"),
            .empty(img: "lightsoff1"),
            .dialogue(text: "Mas o que...", img: "lightsoff2"),
            .dialogue(text: "O que está acontecendo?", img: "lightsoff2"),
            .empty(img: "station1"),
            .dialogue(text: "Ok, isso foi esquisito...", img: "station1"),
            .dialogue(text: "Talvez seja um bom sinal… Alguém\n deve estar trabalhando por aqui\n ainda.", img: "station1"),
            .dialogue(text: "Mas não adianta ficar imaginando\ncoisas. Vou andar um pouco para\nprocurar.", img: "station1"),
            .walk(text: "Andar", img: "station1", imgicon: "walkingleft"),
            .dialogue(text: "[Devo gritar para chamar\nalguém?]", img: "station2"),
        ])
    } 
}

#Preview { 
    GamePlayView()
}


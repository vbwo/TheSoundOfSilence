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
            .dialogue(text: "Talvez seja um bom sinal… Alguém\ndeve estar trabalhando por aqui\nainda.", img: "station1"),
            .dialogue(text: "Mas não adianta ficar imaginando\ncoisas. Vou andar um pouco para\nprocurar.", img: "station1"),
            .walk(text: "Andar", img: "station1", imgicon: "walkingleft"),
            .dialogue(text: "[Devo gritar para chamar\nalguém?]", img: "station2"),
            .miniGames(gameType: .scream(img: "station2game")),
            .dialogue(text: "OOOI? Tem alguém aqui?", img: "station2"),
            .dialogue(text: "[Sem resposta...]", img: "station2"),
            .dialogue(text: "Vou continuar tentando.", img: "station2"), 
            .miniGames(gameType: .scream(img: "station2game")),
            .dialogue(text: "BOA NOITE! Alguém pode me\najudar? Estou presa aqui!", img: "station2"),
            .empty(img: "jump1"),
            .dialogue(text: "Oh, escutei algo vindo dos\ntrilhos!", img: "station2sound"),
            .dialogue(text: "Alguém deve estar por lá...", img: "station2sound"),
            .dialogue(text: "Vou verificar.", img: "station2sound"),
            .walk(text: "Andar", img: "station2sound", imgicon: "walkingleft"),
            .dialogue(text: "[Tem algo ali nos trilhos...\nDeixa eu me aproximar um pouco.]", img: "station3"),
            .empty(img: "feet"),
            .empty(img: "legs"),
            .dialogue(text: "!!!!!!!!!!??????????", img: "legs"),
            .dialogue(text: "O que... é ISSO?!", img: "legs"),
            .dialogue(text: "[Me sinto enjoada, paralisada...\nnão sei o que está acontecendo,\nnem o que fazer.]", img: "bodyzoom"),
            .dialogue(text: "É um corpo... ou metade dele.", img: "bodyzoom"),
            .dialogue(text: "Parece recente e sofrido.", img: "bodyzoom"),
            .dialogue(text: "Não sei o que fazer, não estou\nme sentindo bem. Tenho que ligar\npara a polícia.", img: "bodyzoom"),
            .dialogue(text: "[Na hora que peguei o celular,\nvi uma sombra ao chão...]", img: "stationphone"),
            .dialogue(text: "[Cheguei mais perto para\nenxergar melhor.]", img: "stationphone"),
            .dialogue(text: "...", img: "black"),
            .empty(img: "teke"),
            .dialogue(text: "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!", img: "teke"),
            .dialogue(text: "[Sem ter tempo para raciocinar,\nvirei de costas e corri como se\nminha vida dependesse disso. E,\naparentemente, dependia.]", img: "teke"),
            .walk(text: "Correr", img: "bodyzoom", imgicon: "walkingleft"),
            .dialogue(text: "[Me escondi atrás da primeira\npilastra que vi, tampando a\nboca para não chamar atenção\ncom minha respiração ofegante.]", img: "station4"),    
            .dialogue(text: "[Consigo escutar seu som\ncaracterístico por perto. Tenho\nque fazer silêncio agora.]", img: "station4sound"), 
            .miniGames(gameType: .breath(img: "breathgame")),
            .dialogue(text: "[Acho que despistei por\nenquanto...]", img: "station4"),
            .dialogue(text: "[Devo voltar a correr agora\nantes que aquilo volte.]", img: "station4"),
            .walk(text: "Correr", img: "station4", imgicon: "walkingright"),
            .walk(text: "Entrar", img: "door1", imgicon: "walkingexit2"),
            .dialogue(text: "Acho que estou mais segura\naqui...", img: "camroom"),
            .dialogue(text: "[Isso é uma sala de\nmonitoramento?!]", img: "camroom"),
            .dialogue(text: "Essas câmeras são a única forma\nde eu sair daqui em segurança.\nPreciso ficar de olho nas\nfilmagens.", img: "camroom"),
            .dialogue(text: "Eu posso tentar sair daqui e\ncorrer até essa saída ao norte.\nTem uma leve abertura, acho que\nconsigo entrar ali e...", img: "cam1"),
            .empty(img: "cam2"),
            .dialogue(text: "[O que é isso...?]", img: "cam2"),
            .dialogue(text: "Não...", img: "cam3"),
            .dialogue(text: "Está vindo para cá!!!", img: "cam4"),
            .empty(img: "door1sound"),
            .dialogue(text: "[Preciso segurar a porta!]", img: "door1sound"),
            .miniGames(gameType: .door(img: "doorgame")),
            .dialogue(text: "...", img: "black"),
            .dialogue(text: "Acho que espantei a criatura.\nEssa é minha chance de sair\ndaqui!", img: "black"),
            .dialogue(text: "[Corri em direção à saída\nentreaberta que achei nas\ncâmeras, passando pela abertura\ncom dificuldade.]", img: "black"),
            .empty(img: "black"), 
            .dialogue(text: "Finalmente...", img: "street"),
            .dialogue(text: "Escapei!!!", img: "street"),
            .dialogue(text: "Mas ainda não posso dar bobeira.", img: "street"),
            .dialogue(text: "[Não havia carros na rua, nem\nninguém que eu pudesse pedir\najuda. Devo correr logo para\ncasa.]", img: "street"),
            .empty(img: "black"),
            .dialogue(text: "Cheguei... Estou em casa.", img: "house"),
            .dialogue(text: "Ainda não sei se foi tudo\nverdade ou um pesadelo.", img: "house"),
            .dialogue(text: "Preciso me deitar. Se for um\npesadelo, acordarei.", img: "house"),
            .empty(img: "black"),
            .dialogue(text: "Foi só um pesadelo... acabou.", img: "bedroom"),
            .dialogue(text: "[Fui até a cama, me enrolando\nnos lençóis e estendendo o braço\npara pegar o livro que leio toda\nnoite.]", img: "bedroom"),
            .dialogue(text: "[Oh... O derrubei no chão sem querer.]", img: "bedroom"),
            .dialogue(text: "[Curvei meu corpo para fora da\ncama, a fim de alcançá-lo.]", img: "bluebook"),
            .dialogue(text: "...", img: "bluebook"),
            .dialogue(text: "Mas o que...", img: "book1"),
            
            //---------------//
            //FINAL JUMPSCARE//
            //--------------//
            
            .empty(img: "gameover")
        ])
    }
}

#Preview { 
    GamePlayView()
}


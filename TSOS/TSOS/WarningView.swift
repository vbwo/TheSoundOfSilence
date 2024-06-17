//
//  WarningView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI

struct WarningView: View {
    var body: some View {
       
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            Text("Este jogo contém cenas que podem ser\nperturbadoras para algumas pessoas.\n\nA discrição do jogador é aconselhada.")
                .foregroundStyle(.white)
                .font(.custom("Jura", size: 16))
            
        }
        
    }
}

#Preview {
    WarningView()
}


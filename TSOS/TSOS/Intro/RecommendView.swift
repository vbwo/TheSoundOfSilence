//
//  RecommendView.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 14/06/24.
//

import SwiftUI

struct RecommendView: View {
    var body: some View {
       
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            Text("Para uma melhor experiência,\nsiga as seguintes recomendações:\n\n- Segure seu dispositivo ao jogar;\n- Mantenha as luzes apagadas;\n- Fique em um local silencioso.")
                .foregroundStyle(.white)
                .font(.custom("Jura", size: 16))
            
        }
        
    }
}

#Preview {
    RecommendView()
}


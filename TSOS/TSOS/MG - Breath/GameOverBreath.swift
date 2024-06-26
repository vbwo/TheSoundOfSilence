//
//  GameOverTeste.swift
//  TSOS
//
//  Created by Diego Ferreira Santos on 20/06/24.
//
import CoreHaptics
import SwiftUI

struct GameOverTeste: View {
    
    @Binding var showJumpOver : Bool
    
    var hapticEngine: CHHapticEngine?
    
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
           playHaptic()
           hideImageAfterDelay()
       }

       func hideImageAfterDelay() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                   showJumpOver = false
           }
       }
    
    mutating func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }

    func playHaptic() {
        // Certifique-se de que a engine está preparada
        guard let hapticEngine = hapticEngine else { return }
        
        // Defina o padrão de haptics
        let hapticPattern = try? CHHapticPattern(events: [
            CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0),
            CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
            ], relativeTime: 0.1, duration: 0.5)
        ], parameters: [])
        
        do {
            let player = try hapticEngine.makePlayer(with: hapticPattern!)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    
    }
    
    #Preview {
        CircleGameView()
    }


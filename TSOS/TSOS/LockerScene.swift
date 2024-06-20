//
//  LockerScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI
import CoreHaptics

struct LockerScene: View {
    let img: String
    let updateBackgroundImage: (String) -> Void
    var goToNextScene: () -> Void
    @State private var engine: CHHapticEngine?
    @State private var hasTapped = false
    
    var body: some View {
        VStack {
            Image("locker")
                .onTapGesture {
                    if !hasTapped {  
                        complexSuccess()
                    }
                }
            
            Spacer()
            
            ZStack {
                Rectangle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 212, height: 56, alignment: .leading)
                    .border(Color.white, width: 3)
                Text("Tente forçar o\ncadeado para sair.")
                    .font(Font.custom("PressStart2P-Regular", size: 10))
                    .foregroundColor(.white)
                    .lineSpacing(8)
                    .multilineTextAlignment(.center)
                
            }
        }
        .frame(width: 212, height: 481)
        .padding(.bottom, 88)
        .onAppear {
            prepareHaptics()
            updateBackgroundImage(img)
        }
    }
    
    //MARK: Functions
    
    func prepareHaptics() {
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Start Error: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        hasTapped = true
        
        let newImageName = "exitlockedclick"
        updateBackgroundImage(newImageName)
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            scheduleImageUpdate()
            return
        }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.13)
        let pause = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.17)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.19, duration: 0.13)
        
        events.append(event1)
        events.append(pause)
        events.append(event2)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
            scheduleImageUpdate()
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
            scheduleImageUpdate()
        }
    }
    
    func scheduleImageUpdate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let finalImageName = "exitlocked"
            updateBackgroundImage(finalImageName)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                goToNextScene()
            }
        }
    }
}

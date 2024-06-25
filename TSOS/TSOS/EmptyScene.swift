//
//  EmptyScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 20/06/24.
//

import SwiftUI
import CoreHaptics

struct EmptyScene: View {
    let img: String
    var goToNextScene: () -> Void
    var updateBackgroundImage: (String) -> Void
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        VStack {
            Image(img)
                .ignoresSafeArea()
                .onAppear {
                    if img == "feet" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            goToNextScene()
                            updateBackgroundImage(img)
                        }
                    }
                    if img == "jump1" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            goToNextScene()
                            updateBackgroundImage(img)
                        }
                    }
                    if img == "door1sound" {
                        prepareHaptics()
                        doorHaptics()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            goToNextScene()
                            updateBackgroundImage(img)
                        }
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            goToNextScene()
                            updateBackgroundImage(img)
                        }
                    }
                }
                .onChange(of: img){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        goToNextScene()
                        updateBackgroundImage(img)
                    }
                    if img == "lightsoff1" {
                        prepareHaptics()
                        lightsOffGHaptic()
                    }
                }
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
    
    func lightsOffGHaptic() {
        guard let engine = engine, CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 3)
        
        
        events.append(event1)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    func doorHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        let pause = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.17)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.19, duration: 0.2)
        
        events.append(event1)
        events.append(pause)
        events.append(event2)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
        
    }
}


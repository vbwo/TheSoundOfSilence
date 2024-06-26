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
                    handleImageAppear()
                }
                .onChange(of: img) {
                    handleImageChange()
                }
        }
    }
    
    private func handleImageAppear() {
        switch img {
        case "feet":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                goToNextScene()
            }
        case "jump1":
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                goToNextScene()
            }
        case "door1sound":
            prepareHaptics()
            doorHaptics()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                goToNextScene()
            }
        case "teke":
            prepareHaptics()
            scareHaptics()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                goToNextScene()
            }
        case "black":
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                goToNextScene()
            }
        default:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                goToNextScene()
            }
        }
    }
    
    private func handleImageChange() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            goToNextScene()
        }
        if img == "lightsoff1" {
            prepareHaptics()
            lightsOffGHaptic()
        }
    }
    
    // MARK: - Haptic Functions
    
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
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 3)
        playHaptics(events: [event])
    }

    func doorHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        let pause = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.17)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.19, duration: 0.2)
        playHaptics(events: [event1, pause, event2])
    }

    func scareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 1.5)
        playHaptics(events: [event])
    }

    private func playHaptics(events: [CHHapticEvent]) {
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
}

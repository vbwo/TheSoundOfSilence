//
//  DialogueScene.swift
//  TSOS
//
//  Created by Vitória Beltrão Wenceslau do Ó on 19/06/24.
//

import SwiftUI
import CoreHaptics

struct DialogueScene: View {
    let text: String
    let img: String
    @Binding var displayedText: String
    @Binding var showArrow: Bool
    @Binding var arrowOffset: CGFloat
    @Binding var isShowingText: Bool
    var showText: (String) -> Void
    var animateArrow: () -> Void
    var goToNextScene: () -> Void
    var updateBackgroundImage: (String) -> Void
    @State private var engine: CHHapticEngine?
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black.opacity(0.75))
                .frame(width: 353, height: 128, alignment: .leading)
                .border(Color.white, width: 3)
                .onTapGesture {
                    if isShowingText {
                        isShowingText = false
                    } else if showArrow {
                        goToNextScene()
                    }
                }
            VStack(alignment: .leading) {
                Text(displayedText)
                    .font(Font.custom("PressStart2P-Regular", size: 10))
                    .foregroundColor(.white)
                    .lineSpacing(8)
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear {
                        showText(text)
                    }
                    .onTapGesture {
                        if isShowingText {
                            isShowingText = false
                        } else if showArrow {
                            goToNextScene()
                        }
                    }

                Spacer()

                if showArrow {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundColor(.white)
                        .offset(x: arrowOffset)
                        .frame(height: 20)
                        .padding(.leading, 308)
                        .padding(.bottom, 14)
                        .onAppear {
                            animateArrow()
                        }
                        .onChange(of: showArrow) {
                                animateArrow()
                        }
                }
            }
            .frame(width: 353, height: 128)
        }
        .padding(.bottom, 40)
        .onAppear {
            updateBackgroundImage(img)
            prepareHaptics()
            handleImageAppear()
        }
        .onChange(of: img) {
            updateBackgroundImage(img)
            handleImageChange()
        }
        .onDisappear {
            stopHapticLoop()
        }
    }

    // MARK: - Image Handling

    private func handleImageAppear() {
        switch img {
        case "station2sound":
            prepareHaptics()
            startHapticLoop()
        case "legs", "teke":
            prepareHaptics()
            scareHaptics()
        default:
            break
        }
    }

    private func handleImageChange() {
        switch img {
        case "station2sound", "station4sound":
            prepareHaptics()
            startHapticLoop()
        default:
            stopHapticLoop()
        }
    }

    // MARK: - Haptic Functions

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Haptic engine Start Error: \(error.localizedDescription)")
        }
    }

    func startHapticLoop() {
        stopHapticLoop()
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            tekeHaptics()
        }
    }

    func stopHapticLoop() {
        timer?.invalidate()
        timer = nil
    }

    func tekeHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.1)
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.2, duration: 0.1)
        let event3 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0.8, duration: 0.1)
        let event4 = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 1, duration: 0.1)
        playHaptics(events: [event1, event2, event3, event4])
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

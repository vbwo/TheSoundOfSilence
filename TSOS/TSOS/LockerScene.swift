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
    
    
    var body: some View {
        VStack {
            Image("locker")
                .onTapGesture {
                    complexSuccess()
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
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func complexSuccess() {
           let newImageName = "exitlockedclick"
           updateBackgroundImage(newImageName)
           
           guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
               scheduleImageUpdate()
               return
           }
           
           var events = [CHHapticEvent]()
           
           let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
           let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
           
           let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
           let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0.2)
           
           events.append(event1)
           events.append(event2)
           
           do {
               let pattern = try CHHapticPattern(events: events, parameters: [])
               let player = try engine?.makePlayer(with: pattern)
               try player?.start(atTime: 0)
               scheduleImageUpdate()
           } catch {
               scheduleImageUpdate()
           }
       }
       
       func scheduleImageUpdate() {
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               let finalImageName = "exitlocked"
               updateBackgroundImage(finalImageName)
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                   goToNextScene()
               }
           }
       }
   }

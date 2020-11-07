//
//  ContentView.swift
//  SimpleMicrophone
//
//  Created by Yu Hoto on 2020/11/07.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    private var engine = AVAudioEngine()
    
    @State private var powerIsOn = true
    @State private var volume: Float = 0.3
    
    var body: some View {
        VStack {
            Toggle("Power Switch", isOn: $powerIsOn)
            .onChange(of: powerIsOn, perform: { value in
                toggleEngine(powerIsOn)
            })
            .toggleStyle(SwitchToggleStyle())
            
            Slider(value: $volume, in: 0...1, onEditingChanged: { _ in
                engine.inputNode.volume = volume
            })
        }.padding()
        .onAppear() {
            setupAudioSession()
            let input = engine.inputNode
            let output = engine.outputNode
            let format = engine.inputNode.inputFormat(forBus: 0)
                
            engine.connect(input, to: output, format: format)
            engine.inputNode.volume = volume
            try! engine.start()
        }
    }

    func toggleEngine(_ power: Bool) {
        if power {
            try? engine.start()
        } else {
            try? engine.stop()
        }
    }

    func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, options: [.allowBluetoothA2DP])
            try session.setActive(true)
        } catch {
            fatalError("Failed to configure and activate session.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

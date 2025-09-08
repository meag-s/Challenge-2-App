//
//  Timer.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 8/9/25.
//

import SwiftUI

struct CountdownCameraView: View {
    @State private var counter = 5
    @State private var timerActive = true
    @State private var showCamera = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 40) {
            Text(counter > 0 ? "\(counter)" : "📸 Taking Photo...")
                .font(.system(size: 60, weight: .bold))
                .onReceive(timer) { _ in
                    guard timerActive else { return }
                    
                    if counter > 0 {
                        counter -= 1
                    } else {
                        timerActive = false
                        takePhoto()
                    }
                }
            
            Button("Reset Timer") {
                counter = 5
                timerActive = true
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(camera: CameraModel())
                       
        }
    }
    
    func takePhoto() {
        showCamera = true
    }
}

//#Preview {
//    Timer()
//}

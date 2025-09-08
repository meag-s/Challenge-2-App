//
//  GameView.swift
//  Challenge 2 App
//
//  Created by Dessen Tan on 23/8/25.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                CountdownCameraView()
                CameraView(camera: CameraModel())
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

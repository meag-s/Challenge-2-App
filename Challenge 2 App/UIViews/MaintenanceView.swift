//
//  MaintenanceView.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 13/9/25.
//

import SwiftUI

struct MaintenanceView: View {
    var body: some View {
        ZStack{
            Image("Tape")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text("This mode is current unavailable")
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    MaintenanceView()
}

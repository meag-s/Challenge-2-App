//
//  SettingsView.swift
//  Challenge 2 App
//
//  Created by Dessen Tan on 23/8/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading){
                HStack(alignment: .center, spacing: 100) {
                    Circle()
                        .frame(width: 300, height: 300)
                        .foregroundColor(.blue)
                    VStack (alignment: .leading, spacing: 30){
                        Text("Name")
                            .font(.largeTitle)
                            .bold()
                        HStack (spacing: 35){
                            VStack{
                                Text ("0")
                                    .font(.title)
                                Text ("photo strips taken")
                                    .font(.title2)
                            }
                            VStack{
                                Text ("0")
                                    .font(.title)
                                Text ("overall accuracy")
                                    .font(.title2)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}


#Preview {
    SettingsView()
}

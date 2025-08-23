//
//  ContentView.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 2/8/25.
//

import SwiftUI


struct ContentView: View {
    let radius: CGFloat = 30
    let width: CGFloat = 350
    let height: CGFloat = 100
    let font: CGFloat = 40
    let padding: CGFloat = 10
    var body: some View {
        NavigationStack{
            HStack {
                NavigationLink{
                    GameView()
                }label: {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(Color(red: 101/255, green: 214/255, blue: 117/255))
                        .frame(width: width, height: height)
                        .padding(padding)
                        .border(Color(red: 61/255, green: 155/255, blue: 76/255), width: 10)
                        .overlay{
                            Text("Start")
                                .foregroundStyle(.white)
                                .font(.system(size: font))
                        }
                }
                
                NavigationLink{
                    SettingsView()
                }label: {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundColor(Color(red: 101/255, green: 214/255, blue: 117/255))
                        .frame(width: width, height: height)
                        .padding(padding)
                        .overlay{
                            Text("Settings")
                                .foregroundStyle(.white)
                                .font(.system(size: font))
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

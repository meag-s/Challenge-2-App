//
//  DifficultyView.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 23/8/25.
//

import SwiftUI

struct DifficultyView: View {
    let radius: CGFloat = 30
    let width: CGFloat = 320
    let height: CGFloat = 100
    let font: CGFloat = 40
    let padding: CGFloat = 10
    var body: some View {
        NavigationStack{
            VStack{
                Text("Select Difficulty")
                    .font(.system(size:45))
                HStack {
                    NavigationLink{
                        GameView()
                    }label: {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(Color(red: 101/255, green: 214/255, blue: 117/255))
                            .frame(width: width, height: height)
                            .padding(padding)
                            .overlay{
                                Text("Easy")
                                    .foregroundStyle(.white)
                                    .font(.system(size: font))
                            }
                    }
                    NavigationLink{
                        MaintenceView()
                    }label: {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(Color(red: 220/255, green: 200/255, blue: 0/255))
                            .frame(width: width, height: height)
                            .padding(padding)
                            .overlay{
                                Text("Medium")
                                    .foregroundStyle(.white)
                                    .font(.system(size: font))
                            }
                    }
                    
                    NavigationLink{
                        MaintenceView()
                    }label: {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(Color(red: 255/255, green: 50/255, blue: 50/255))
                            .frame(width: width, height: height)
                            .padding(padding)
                            .overlay{
                                Text("Hard")
                                    .foregroundStyle(.white)
                                    .font(.system(size: font))
                            }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    DifficultyView()
}

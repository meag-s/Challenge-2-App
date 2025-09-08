//
//  PlayerCountView.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 23/8/25.
//

import SwiftUI

struct PlayerCountView: View {
    @State var playerCount: Int = 2
    var body: some View {
        NavigationStack{
            VStack (alignment: .center, spacing: 30){
                Text("No. of players:")
                    .font(.system(size:40))
                
                HStack (alignment: .center, spacing: 50){
                    Button{
                        if playerCount != 2 {
                            playerCount += 1
                        }
                    } label: {
                        Text("+")
                            .font(.system(size:50))
                    }
                    
                    
                    Text("\(playerCount)")
                        .font(.system(size:50))
                    
                    
                    Button{
                        if playerCount != 1 {
                            playerCount -= 1
                        }
                    } label: {
                        Text ("-")
                            .font(.system(size:50))
                    }
                    
                }
            }
            .padding()
            .toolbar{
                if playerCount == 1 {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink{
                            DifficultyView()
                        } label: {
                            Text ("Next")
                                .font(.system(size:25))
                        }
                    }
                } else {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink{
                            DuoPlayerView()
                        } label: {
                            Text ("Next")
                                .font(.system(size:25))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PlayerCountView()
}

struct DuoPlayerView: View {
    var body: some View {
        ZStack{
            Image("Tape")
                .resizable()
                .aspectRatio(contentMode: .fill)
            Text("Two player coming soon")
        }
        .ignoresSafeArea(.all)
    }
}

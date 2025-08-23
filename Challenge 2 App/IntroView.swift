//
//  IntroView.swift
//  Challenge 2 App
//
//  Created by Meagan Sim on 23/8/25.
//

import SwiftUI

struct IntroView: View {
    @State var name : String = ""
    var body: some View {
        NavigationStack{
            VStack(alignment:.center){
                Text("What is your name?")
                TextField ("Name", text: $name)
                    .border(.secondary)
            }
        }
    }
}

#Preview {
    IntroView()
}

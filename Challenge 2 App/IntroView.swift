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
        
        VStack(alignment:.center){
            Spacer()
            Text("What is your name?")
                .font(.largeTitle)
                .bold()
            TextField ("Name", text: $name)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 500)
                .shadow(radius: 3)
            Spacer()
        }
    }
}

#Preview {
    IntroView()
}

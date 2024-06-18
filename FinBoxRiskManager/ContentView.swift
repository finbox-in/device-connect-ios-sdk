//
//  ContentView.swift
//  FinBoxRiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import SwiftUI
import RiskManager

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: {
                startDC()
            }) {
                Text("Start DC")
                    .padding(8)
                    .frame(width: 100)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

func startDC() {
    let finBox = FinBox()
    finBox.createUser()
    finBox.startPeriodicSync()
}

#Preview {
    ContentView()
}

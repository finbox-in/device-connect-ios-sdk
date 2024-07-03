//
//  ContentView.swift
//  FinBoxRiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import SwiftUI
import RiskManager

private var INSTANCE: FinBox? = nil

func getFinBoxInstance() -> FinBox {
    if (INSTANCE == nil) {
        INSTANCE = FinBox()
    }
    return INSTANCE!
}

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
    let finBox = getFinBoxInstance()
    finBox.createUser()
    finBox.setSyncFrequency(value: 10, unit: Calendar.Component.second)
    finBox.startPeriodicSync()
}

#Preview {
    ContentView()
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        getFinBoxInstance().scheduleBackgroundRefreshTask()
        return true
    }
}

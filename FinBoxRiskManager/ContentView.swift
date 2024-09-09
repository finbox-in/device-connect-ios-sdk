//
//  ContentView.swift
//  FinBoxRiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import SwiftUI
import RiskManager
import BackgroundTasks
import CoreLocation

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    
    // Flag to track access grant status
    // Used to control visibility of alert
    var accessGranted = true

    // Flag to control visibility of Alert
    // Used to avoid calling show alert when it's already visible
    @State private var alertPresented = false
    
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
        }.onAppear {
            locationManager.checkLocationPermission()
        }.alert(isPresented: $alertPresented) {
            Alert(title: Text("Location Permission Denied"),
                  message: Text("Please enable location permissions in settings to use this feature."),
                  dismissButton: .default(Text("OK")))
        }
        .onChange(of: locationManager.authorizationStatus) { status in
            if status == .denied || status == .restricted {
                alertPresented = true
            }
        }
    }
}

func startDC() {
    let customerId = getUsername()
    debugPrint("Customer Id: \(customerId)")
    FinBox.createUser(
        apiKey: "YOUR_API_KEY",
        customerId: customerId,
        success: { success in
            debugPrint("Success: \(success)")
            let finBox = FinBox()
            finBox.setSyncFrequency(value: 10, unit: Calendar.Component.second)
            finBox.startPeriodicSync()
        },
        error: { error in
            debugPrint("Error in createUser: \(error)")
        }
    )
    
    // Call printT after a delay of 15 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
        printTasks()
    }
    
    func getUsername() -> String {
        return "demo_lender_" + getDateTime()
    }

    func getDateTime() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        // Get month, day, hour and minute
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)
        return String(day) + String(month) + String(hour) + String(minute)
    }
}

func printTasks() {
    BGTaskScheduler.shared.getPendingTaskRequests { taskRequests in
        for taskRequest in taskRequests {
            if let taskRequest = taskRequest as? BGAppRefreshTaskRequest {
                // Handle BGAppRefreshTaskRequest
                debugPrint("Pending App Refresh Task Request: \(taskRequest)")
            } else if let taskRequest = taskRequest as? BGProcessingTaskRequest {
                // Handle BGProcessingTaskRequest
                debugPrint("Pending Processing Task Request: \(taskRequest)")
            }
            // Add handling for other types of task requests if necessary
        }
    }
}

#Preview {
    ContentView()
}

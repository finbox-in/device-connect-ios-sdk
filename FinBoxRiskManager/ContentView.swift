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
import AppTrackingTransparency

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    
    // Customer Id Text Component
    @State
    private var customerId = ""
    
    // Error Text Component
    @State
    private var errorText = ""
    
    // Flag to track access grant status
    // Used to control visibility of alert
    var accessGranted = true

    // Flag to control visibility of Alert
    // Used to avoid calling show alert when it's already visible
    @State private var alertPresented = false
    
    var body: some View {
        VStack {
            // Customer Details Text
            Text(customerId)
                .padding(8)
                .fixedSize(horizontal: false, vertical: true) // Prevent resizing
            
            // Start Sync
            Button(action: {
                statSync()
            }) {
                Text("Start Sync")
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .shadow(radius: 5)
            }
            
            // Error Text
            Text(errorText)
                .padding(8)
                .foregroundColor(.red)
                .fixedSize(horizontal: false, vertical: true) // Prevent resizing
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
            else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    requestAdvertisingPermission()
                }
            }
        }
    }
    
    private func requestAdvertisingPermission() {
        debugPrint("Request Advertising Permission")
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("Tracking permission granted")
                // Access the IDFA and proceed with targeted advertising
            case .denied, .restricted:
                print("Tracking permission denied or restricted")
                // Handle the case where permission is denied or restricted
            case .notDetermined:
                print("Tracking permission not determined yet")
            @unknown default:
                break
            }
        }
    }
    
    private func statSync() {
        withAnimation {
            self.customerId = getUsername()
        }
        debugPrint("Customer Id: \(customerId)")
        FinBox.createUser(
            apiKey: "YOUR_API_KEY",
            customerId: customerId,
            success: { success in
                debugPrint("Success: \(success)")
                
                // Sync the data
                let finBox = FinBox()
                finBox.setSyncFrequency(value: 10, unit: Calendar.Component.second)
                finBox.startPeriodicSync()
                
                // Reset the error text
                if errorText != "" {
                    withAnimation {
                        errorText = ""
                    }
                }
            },
            error: { error in
                withAnimation {
                    // Show the error
                    errorText = String(error.rawValue)
                }
                debugPrint("Error in createUser: \(error)")
            }
        )
        
        // Call printT after a delay of 15 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 15.0) {
            printTasks()
        }
    }
    
    private func getUsername() -> String {
        return "demo_lender_" + getDateTime()
    }

    private func getDateTime() -> String {
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

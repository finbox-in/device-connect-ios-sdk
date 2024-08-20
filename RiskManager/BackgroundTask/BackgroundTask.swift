//
//  BackgroungTask.swift
//  RiskManager
//
//  Created by Ashutosh Jena on 02/07/24.
//

import Foundation
import UIKit
import BackgroundTasks

/// FinBox + BG Task
extension FinBox {
    
    // Sync Frequency
    private var syncFrequency: TimeInterval {
        get { SyncPref().syncFrequency }
        set { SyncPref().syncFrequency = newValue }
    }
    
    // MARK: Register Background Tasks
    /// Internal method to register background tasks and notifications.
    internal func registerBackgroundTasks() {
        // Schedule the background refresh task
        scheduleBackgroundRefreshTask()
        
        // Add observer for app resigning active state notification
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }
    
    
    /// Public method to schedule a background refresh task.
    public func scheduleBackgroundRefreshTask() {
        // Register the background task with a specific identifier
        let isRegistered = BGTaskScheduler.shared.register(forTaskWithIdentifier: BACKGROUND_TASK_IDENTIFIER, using: nil) { task in
            debugPrint("App refresh task registered successfully")
            
            // Handle the app refresh task
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        print("Task scheduled? : \(isRegistered)")
    }
    
    
    /// Handles the background app refresh task.
    ///
    /// - Parameter task: The background app refresh task (`BGAppRefreshTask`) to handle.
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        debugPrint("App Refresh Task in handleAppRefreshTask")
        
        // Set an expiration handler for the task
        task.expirationHandler = { [weak self] in
            // Reschedule the background refresh task
            self?.scheduleBackgroundRefreshTask()
            
            // Mark the task as completed
            task.setTaskCompleted(success: true)
        }
        
        // Call the startPeriodicDataSync() method to initiate data synchronization
        self.startPeriodicDataSync()
        
        // Schedule the background refresh task
        self.scheduleBackgroundRefreshTask()
        
        // Mark the task as completed
        task.setTaskCompleted(success: true)
    }
    
    
    /// Handles the notification when the app is about to resign active state.
    /// When an iOS app is said to "resign active state," it means that the app is no longer the foreground app and is about to transition into the background. This transition typically occurs in response to user actions, such as pressing the home button, receiving a phone call, or accessing the Control Center.
    @objc func willResignActive(_ notification: Notification) {
        // Schedule data synchronization when the app is about to resign active state
        scheduleSyncData()
    }
    
    
    
    /// Schedules a background task to sync data with a specified frequency.
    func scheduleSyncData() {
        // Get the current date
        let startDate = Date()
        
        // Get the current calendar object
        let calendar = Calendar.current
        
        // Calculate the date to schedule the task, adding syncFrequency seconds to startDate
        let date = calendar.date(byAdding: .second, value: Int(self.syncFrequency), to: startDate)
        
        // Create a BGAppRefreshTaskRequest with a specific identifier
        let request = BGAppRefreshTaskRequest(identifier: BACKGROUND_TASK_IDENTIFIER)
        // request.earliestBeginDate = date // Set the earliest begin date for the task
        
        request.earliestBeginDate = Date(timeIntervalSinceNow: 28800)
        
        debugPrint("Current Date: \(startDate)")
        debugPrint("Sync Frequency: \(self.syncFrequency) seconds")
        debugPrint("Scheduled Date: \(date)")
        
        debugPrint("Earliest Begin Date: \(request.earliestBeginDate)")
        printCurrentTime()
        
        // Submit the task request to the BGTaskScheduler
        do {
            try BGTaskScheduler.shared.submit(request)
            debugPrint("BG Task submitted successfully with frequency: \(self.syncFrequency)")
        } catch {
            debugPrint("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func printCurrentTime() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedDate = dateFormatter.string(from: currentDate)
        print("Current Time: \(formattedDate)")
    }
    
    
    /// Sets the frequency for background sync tasks and saves it to SyncPref.
    ///
    /// - Parameters:
    ///   - value: The numeric value of the frequency.
    ///   - unit: The unit of time for the frequency (day, hour, minute, or second).
    public func setSyncFrequency(value: Int, unit: Calendar.Component) {
        switch unit {
        case .day:
            syncFrequency = Double(value) * 24 * 60 * 60 // Convert days to seconds
        case .hour:
            syncFrequency = Double(value) * 60 * 60 // Convert hours to seconds
        case .minute:
            syncFrequency = Double(value) * 60 // Convert minutes to seconds
        default:
            syncFrequency = Double(value) // Default unit is seconds
        }
        
        // The computed property `syncFrequency` will store the value in SyncPref
    }
    
    private func startPeriodicDataSync() {
        print("Doing bg task")
        // Fetch Device Data
        let deviceData = DeviceData()
        deviceData.syncDeviceData()
        
        // Fetch Location Data
        DispatchQueue.main.async {
            let locationData = LocationData()
            locationData.syncLocationData()
        }
        
//        let deviceData = DeviceData().getDeviceData()
//        print("Syncing Device Data Periodically", deviceData)
//        
//        // Fetch Location Data
//        LocationData().getLocationData { location in
//            print("Syncing Location Data Periodically: \(location)")
//        }
    }
}

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
    public func setup() {
        registerBackgroundTasks()
    }

    internal func registerBackgroundTasks() {
        scheduleBackgroundRefreshTask()
        
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIScene.willDeactivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        }
    }

    public func scheduleBackgroundRefreshTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: BACKGROUND_TASK_IDENTIFIER, using: nil) { task in
            debugPrint("App refresh task registered successfully")
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
    }

    func handleAppRefreshTask(task: BGAppRefreshTask) {
        debugPrint("App Refresh Task in handleAppRefreshTask")
        task.expirationHandler = { [weak self] in
            self?.scheduleBackgroundRefreshTask()
            task.setTaskCompleted(success: true)
        }
        
        // Call the startPeriodicDataSync() method here
        self.startPeriodicDataSync()
        
        self.scheduleBackgroundRefreshTask()
        task.setTaskCompleted(success: true)
    }

    @objc func willResignActive(_ notification: Notification) {
        scheduleSyncData()
    }

    func scheduleSyncData() {
        let startDate = Date()
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .second, value: Int(self.syncFrequency), to: startDate)
        
        let request = BGAppRefreshTaskRequest(identifier: BACKGROUND_TASK_IDENTIFIER)
        request.earliestBeginDate = date
        
        do {
            try BGTaskScheduler.shared.submit(request)
            debugPrint("BG Task submitted successfully with frequency: \(self.syncFrequency)")
        } catch {
            debugPrint("Unable to submit task: \(error.localizedDescription)")
        }
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
        // Fetch Device Data
        let deviceData = DeviceData().getDeviceData()
        print("Syncing Device Data Periodically", deviceData)
        
        // Fetch Location Data
        LocationData().getLocationData { location in
            print("Syncing Location Data Periodically: \(location)")
        }
    }
}

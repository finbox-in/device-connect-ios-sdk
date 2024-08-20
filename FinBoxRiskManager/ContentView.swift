//
//  ContentView.swift
//  FinBoxRiskManager
//
//  Created by Ashutosh Jena on 07/06/24.
//

import SwiftUI
import RiskManager
import BackgroundTasks

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
    let customerId = getUsername()
    debugPrint("Customer Id: \(customerId)")
    FinBox.createUser(
        apiKey: "I9G9Js79et7ykyLCnFp279XxsJH85Jpu3d5E2Log",
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

//Task scheduled? : true
//Device Data ["sound": ["output": ["Speaker"], "input": [], "volume": 0.90000004], "personalization": ["timezone": "Asia/Kolkata", "fonts": ["Academy Engraved LET", "Al Nile", "American Typewriter", "Apple Color Emoji", "Apple SD Gothic Neo", "Apple Symbols", "Arial", "Arial Hebrew", "Arial Rounded MT Bold", "Avenir", "Avenir Next", "Avenir Next Condensed", "Baskerville", "Bodoni 72", "Bodoni 72 Oldstyle", "Bodoni 72 Smallcaps", "Bodoni Ornaments", "Bradley Hand", "Chalkboard SE", "Chalkduster", "Charter", "Cochin", "Copperplate", "Courier New", "Damascus", "Devanagari Sangam MN", "Didot", "DIN Alternate", "DIN Condensed", "Euphemia UCAS", "Farah", "Futura", "Galvji", "Geeza Pro", "Georgia", "Gill Sans", "Grantha Sangam MN", "Helvetica", "Helvetica Neue", "Hiragino Maru Gothic ProN", "Hiragino Mincho ProN", "Hiragino Sans", "Hoefler Text", "Impact", "Kailasa", "Kefa", "Khmer Sangam MN", "Kohinoor Bangla", "Kohinoor Devanagari", "Kohinoor Gujarati", "Kohinoor Telugu", "Lao Sangam MN", "Malayalam Sangam MN", "Marker Felt", "Menlo", "Mishafi", "Mukta Mahee", "Myanmar Sangam MN", "Noteworthy", "Noto Nastaliq Urdu", "Noto Sans Kannada", "Noto Sans Myanmar", "Noto Sans Oriya", "Optima", "Palatino", "Papyrus", "Party LET", "PingFang HK", "PingFang SC", "PingFang TC", "Rockwell", "Savoye LET", "Sinhala Sangam MN", "Snell Roundhand", "STIX Two Math", "STIX Two Text", "Symbol", "Tamil Sangam MN", "Thonburi", "Times New Roman", "Trebuchet MS", "Verdana", "Zapf Dingbats", "Zapfino"], "currency": "INR", "language": "en_IN", "country": "IN", "keyboards": ["en-IN", "hi", "emoji"], "calendar": "gregorian"], "systemInfo": ["totalRam": 4034985984, "uptime": 11373.25250325, "cpu": ["availableProcessors": 6], "storage": ["totalSpace": 63933894656, "freeSpace": 33169653760], "isMultitasking": true, "elapsedTimeMillis": "11373252"], "adverisementId": "20D9C029-DBCF-4BBF-8BE6-C3550445C258", "backgroundRefreshStatus": 2, "network": ["networkType": "WIFI", "activeNetworkTypeName": "WIFI", "addresses": [["ifaName": "lo0", "ip": "127.0.0.1"], ["ip": "::1", "ifaName": "lo0"], ["ip": "fe80::1%lo0", "ifaName": "lo0"], ["ifaName": "en0", "ip": "fe80::1c7e:987b:79d6:6ba2%en0"], ["ip": "10.11.11.125", "ifaName": "en0"], ["ifaName": "utun0", "ip": "fe80::a1ed:5c27:f434:ee6f%utun0"], ["ip": "fe80::9ccf:643f:4d26:770d%utun1", "ifaName": "utun1"], ["ip": "fe80::9ee2:42ad:f421:b3a3%utun2", "ifaName": "utun2"], ["ifaName": "utun3", "ip": "fe80::ce81:b1c:bd2c:69e%utun3"], ["ifaName": "anpi0", "ip": "fe80::605f:23ff:fe21:8360%anpi0"], ["ip": "fe80::c88:1261:3f79:9409%en2", "ifaName": "en2"], ["ifaName": "en2", "ip": "169.254.170.144"], ["ip": "fe80::f4b6:cff:feee:341d%awdl0", "ifaName": "awdl0"], ["ifaName": "llw0", "ip": "fe80::f4b6:cff:feee:341d%llw0"], ["ip": "fe80::20ed:f6c0:77cb:bcaf%utun4", "ifaName": "utun4"], ["ip": "fdce:d5e4:8324::1", "ifaName": "utun4"]]], "display": ["heightPixels": 896.0, "widthPixels": 414.0], "deviceInfo": ["kernVersion": "Darwin Kernel Version 23.5.0: Wed May  1 20:34:59 PDT 2024; root:xnu-10063.122.3~3/RELEASE_ARM64_T8030", "kernOSType": "Darwin", "kernOSVersion": "21F90", "deviceModelRawName": "iPhone12,1", "hwMachine": "iPhone", "displayLanguage": "en", "hwProduct": "iPhone", "userName": "", "syncId": "DF4B2034-AD9F-4ACF-9517-EAE91F049332", "hwModel": "iPhone12,1", "kernOSRelease": "23.5.0", "hwTarget": "iPhone12,1", "sdkVersionName": "1.0", "activeNetworkTypeName": "WIFI", "vendorId": "20D9C029-DBCF-4BBF-8BE6-C3550445C258", "isRealTime": false, "syncMechanism": 1, "userHash": "95D27CD5-CC8A-4769-B132-250C7E401DB1", "deviceName": "iPhone", "batchId": "0B7504F0-C67A-49EC-BEB0-7EAC57B458AB", "osVersion": "17.5.1", "networkType": "WIFI", "kernHostname": "localhost", "localizedModel": "iPhone", "systemName": "iOS"], "battery": ["status": 2, "level": 100.0]]
//"Current Date: 2024-07-04 12:20:01 +0000"
//"Sync Frequency: 10.0 seconds"
//"Scheduled Date: Optional(2024-07-04 12:20:11 +0000)"
//"Earliest Begin Date: Optional(2024-07-04 12:20:11 +0000)"
//Current Time: 2024-07-04 17:50:01
//"BG Task submitted successfully with frequency: 10.0"
//"Requesting location access."
//"Access to location services denied."
//"Access granted."
//Location Data: ["latitude": 12.912534576101871, "longitude": 77.64875519766245]
//"Pending App Refresh Task Request: <BGAppRefreshTaskRequest: in.finbox.riskmanager.SyncTask, earliestBeginDate: 2024-07-04 12:20:11 +0000>"
//"Access to location services denied."
//"Access to location services denied."
//"App refresh task registered successfully"
//"App Refresh Task in handleAppRefreshTask"
//Doing bg task
//*** Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'All launch handlers must be registered before application finishes launching'
//*** First throw call stack:
//(0x199468f20 0x19131e018 0x19896f868 0x2157cb674 0x2157cb4ac 0x10518fc10 0x105190140 0x10518ff24 0x1051901a8 0x2157cd144 0x105db8b98 0x105dba7bc 0x105dc266c 0x105dc343c 0x105dd0404 0x105dcfa38 0x1f62bf934 0x1f62bc0cc)
//libc++abi: terminating due to uncaught exception of type NSException
//Type: stdio

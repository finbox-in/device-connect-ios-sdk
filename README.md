# DeviceConnect IOS SDK

Device Connect IOS SDK is used to collect anonymised non-PII data from the devices of the users after taking explicit user consent.

## Requirements

Device Connect IOS SDK works on IOS 14.0 and Xcode 14.1.

## Adding Dependency

Add the SDK to the application using Cocopods.

1. Edit the `pod` file and add `pod 'RiskManager'`

## Create User

Call `createUser` method to create the user. It takes Client Api Key and Customer Id as the arguments.

The response to this method (success or failure) can be captured using the callback.


```swift
Finbox.createUser(apiKey: "API_KEY", customerId: "CUSTOMER_ID") { token in
    // Authentication is success
} error: { code in
    // Authentication failed
}
```

## Start Periodic Sync

This is to be called only on a successful response to `createUser` method's callback. On calling this the syncs will start for all the data sources configured as per permissions. The method below syncs data in the background at regular intervals.


```swift
let finbox = FinBox()
finbox.startPeriodicSync()
```


## Cancel Periodic Sync

If you have already set up the sync for the user, cancel the syncs using `stopPeriodicSync` method.


```swift
finbox.stopPeriodicSync()
```


## Handle Sync Frequency

By default sync frequency is set to **8 hours**, you can modify it by passing preferred time **in seconds** as an argument to `setSyncFrequency` method once the user is created.


```swift
finbox.setSyncFrequency(12 * 60 * 60)
```


## Reset User Data

In case the user data needs to be removed on the device so that you can re-sync the entire data, use the method `resetData`.


```swift
FinBox.resetData()
```


## Forget User

In case the user choose to be forgotten, use the method `forgetUser`. This will delete the user details in our system.


```swift
FinBox.forgetUser()
```

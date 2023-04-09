# BatteryStation

This simple iOS application allows up to 6 devices (iPhone or iPad) to monitor each other's battery level and status (eg. charging or not charging),
after establishing a simple connection via Wifi/Bluetooth.

To connect:

- Open app; the Browser screen appears (or hit "Tap to browse for more peers" to show Browser again later
- Select from list of devices that are in-range (sends a connection-invitation to that device)
- On the selected device, hit "Accept" to connect (accepts the connection-invitation)

To see battery info:

- Hit "Done" or "Cancel" from Browser view to show main screen (connected peers screen)

Note, due to Apple-imposed limitations, if the app is terminated or dismissed to the background on any connected device, its connection is dropped and within 10 seconds no longer shows on previously-connected peer devices' displays.

See "Notes" below for more on Wifi/Bluetooth connections and Apple's imposed limitations on using these technologies.

Demo:

https://user-images.githubusercontent.com/47217795/230691644-0a180d9e-ac9b-4a14-9c60-a2caa58cdca6.mov


Notes:

MultipeerConnectivity:

This app uses MultipeerConnectivity, a framework that was found to be better-supported by Apple than pure Bluetooth (CoreBluetooth) for maintaining connections between iOS devices (at time of writing, April 2023).

From Apple Docs., "In iOS, [MultipeerConnectivity] uses infrastructure Wi-Fi networks, peer-to-peer Wi-Fi, and Bluetooth personal area networks for the underlying transport." [https://developer.apple.com/documentation/multipeerconnectivity]

Limitations:

Unfortunately, Apple imposes several limitations on iOS devices by their framework engineering decisions; those relevant to this use-case were found at time of writing to be:
- (a) Background execution prohibited ... MultipeerConnectivity does not permit wireless connection to/from a device once the app is dismissed to the background or closed on that device
- (b) Regular Bluetooth connection not supported ... It was found that for newer iOS versions, Bluetooth is also not supported by Apple for this use-case of continuous connection and data transfer between iOS devices. This used to work using CoreBluetooth, but was deprecated (otherwise this app would have used CoreBluetooth instead of MultipeerConnectivity)
- (c) Device names permissions ... this is a minor issue (it can be removed by applying to "request the entitlement" required by Apple) - but on newer devices (iOS >= 16), custom device names (under Settings app / General/About/Name), are NOT recognized by default and are replaced with generic ones (eg. "iPhone"), creating ambiguity in managing multiple device-connections
- * Developer's note, (c) will be addressed when I have the time, especially before potentially submitting anything to the App Store -gladius

Documentation:

- (a) above: see  https://developer.apple.com/documentation/multipeerconnectivity - from Docs.: "If the app moves into the background, the framework stops advertising and browsing and disconnects any open sessions. Upon returning to the foreground, the framework automatically resumes advertising and browsing, but the developer must reestablish any closed sessions."
- (b) above: To test this on your own devices, just try connecting over Bluetooth to any iOS device from within another iOS device via Settings/Bluetooth -- most likely it will say "Pairing Unsuccessful / [device] is not supported" or "/ Make sure [device] is turned on, in range,..."). For more insight on this see: https://discussions.apple.com/docs/DOC-7722
- (c) above: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_device-information_user-assigned-device-name

Todo list: 

[Forks / PRs warmly encouraged, for anyone interested in this framework. This project is at least as much a test bed for MultipeerConnectivity as a would-be practically useful app, due to the technology's limitations]

[1] Implementing a nicer way to "reestablish any closed sessions" [ie. from Documentation quote in (a) above) 

-> that is, upon the disconnection of one peer, for all 'other' peers to detect, and save state of, this disconnection event (eg with an AppDelegate Bool) to later allow these 'others' to send a new connection invitation by triggering a trySendingBatteryData() call once a new connection is detected

[2] Can show if a peer device is in Low Power Mode?

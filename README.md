# BatteryStation

This simple iOS application allows up to 6 devices (iPhone or iPad) to monitor each other's battery level and status (eg. charging or not charging),
after establishing a simple connection via Wifi/Bluetooth [1].

To connect:

- Open app; the Browser screen appears (or hit "Tap to browse for more peers" to show Browser again later
- Select from list of devices that are in-range (sends a connection-invitation to that device)
- On the selected device, hit "Accept" to connect (accepts the connection-invitation)

To see battery info:

- Hit "Done" or "Cancel" from Browser view to show main screen (connected peers screen)
- Note, due to Apple-imposed limitations, if the app is terminated or dismissed to the background on any connected device, its connection is dropped and within 10 seconds will be removed from all other connected peer devices' displays (list or menu)

[Also see "Notes" below for more about Wifi/Bluetooth connections and Apple's imposed limitations on using these technologies.]

Demo:

https://user-images.githubusercontent.com/47217795/230691644-0a180d9e-ac9b-4a14-9c60-a2caa58cdca6.mov


Notes:

[1] MultipeerConnectivity:

This app uses MultipeerConnectivity, a framework that was found to be better-supported by Apple than pure Bluetooth (CoreBluetooth) for maintaining connections between iOS devices (at time of writing, April 2023).

From Apple Docs., "In iOS, [MultipeerConnectivity] uses infrastructure Wi-Fi networks, peer-to-peer Wi-Fi, and Bluetooth personal area networks for the underlying transport." [https://developer.apple.com/documentation/multipeerconnectivity]

[2] Limitations:

Unfortunately, Apple imposes several limitations on iOS devices by their framework engineering decisions; those relevant to this use-case were found at time of writing to be:
- (a) Background execution prohibited ... MultipeerConnectivity does not permit wireless connection to/from a device once the app is dismissed to the background or closed on that device
- (b) Regular Bluetooth connection not supported ... It was found that for newer iOS versions, Bluetooth is also not supported by Apple for this use-case of continuous connection and data transfer between iOS devices. This used to work using CoreBluetooth, but was deprecated
- (c) Device names permissions ... this is a minor issue (it can be removed by applying to "request the entitlement" required by Apple) - but on newer devices (iOS >= 16), custom device names (under Settings app / General/About/Name), are NOT recognized by default and are replaced with generic ones (eg. "iPhone"), creating ambiguity in managing multiple device-connections
- * Developer's note, (c) will be addressed when I get some free time, especially if this app is submitted to the App Store -gladius

[3] Documentation:

- (a) above: see  https://developer.apple.com/documentation/multipeerconnectivity - from Docs.: "If the app moves into the background, the framework stops advertising and browsing and disconnects any open sessions. Upon returning to the foreground, the framework automatically resumes advertising and browsing, but the developer must reestablish any closed sessions."
- (b) above: To test this on your own devices, just try connecting over Bluetooth to any iOS device from within another iOS device via Settings/Bluetooth -- most likely it will say "Pairing Unsuccessful / [device] is not supported" or "/ Make sure [device] is turned on, in range,..."). For more insight on this see: https://discussions.apple.com/docs/DOC-7722
- (c) above: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_device-information_user-assigned-device-name

Contributions:

- Forks and pull requests warmly encouraged, for anyone who is interested in this framework. This project was quickly created with a purposely-simple design precisely to be a test-bed for working with the powerful yet compromise-ridden MultipeerConnectivity framework, as much as for this app's narrow function.

Todo list:

- Implementing a nicer way to "reestablish any closed sessions" [ie. from Documentation quote in (a) above) 

-> that is, upon the disconnection of one peer, for all 'other' peers to detect, and save state of, this disconnection event (eg with an AppDelegate Bool) to later allow these 'others' to send a new connection invitation by triggering a trySendingBatteryData() call once a new connection is detected

- Can show if a peer device is in Low Power Mode?

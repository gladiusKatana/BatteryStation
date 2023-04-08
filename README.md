# BatteryStation

This simple iOS application allows up to 6 devices (iPhone or iPad) to monitor each other's battery level and status (eg. charging or not charging),
after establishing a simple connection via Wifi/Bluetooth [1].

To connect:
-Open app; the Browser screen appears (or hit "tap to browse for more peers" to show Browser again
-Select from list of devices that are in-range (sends a connection-invitation)
-On the selected device, hit "Accept" to connect (accepts the connection-invitation)

To see battery info:
-Hit "Done" from Browser view to show main screen (connected peers screen)
-Note, if app is terminated or dismissed to background on any connected device, after 10 seconds its connection will be dropped on all other connected peers (ie connected instances of the app)

[check out below Demo, and Notes for background on Wifi/Bluetooth connections and limitations imposed by Apple on supporting these technologies.]

Demo:

https://user-images.githubusercontent.com/47217795/230691644-0a180d9e-ac9b-4a14-9c60-a2caa58cdca6.mov


Notes:

[1] this app uses MultipeerConnectivity, a framework that has generally been more supported by Apple than pure Bluetooth (CoreBluetooth) for connection between iOS devices (at time of writing, April 2023).
From Apple Docs., "In iOS, [MultipeerConnectivity] uses infrastructure Wi-Fi networks, peer-to-peer Wi-Fi, and Bluetooth personal area networks for the underlying transport."

[2] Limitations:
Unfortunately due to Apple's framework decisions, limitations are imposed on iOS devices:
(a) background execution prohibited:  when an app is dismissed to the background or closed, wireless connection is no longer permitted between devices via MultipeerConnectivity
(b) pure bluetooth not supported:  if we wanted to use pure Bluetooth instead of MultipeerConnectivity, well, that capability was deprecated by Apple as well, for newer iOS versions... just try connecting any iOS device from within another, via Settings app / "Bluetooth", most likely it will say "Pairing Unsuccessful / [name] is not supported" or "/ Make sure [name is turned on, in range,..."
(c) device names permissions:  this is a minor issue that can be resolved by applying for permission with Apple - but on newer devices (iOS >= 16), custom device names (under Settings/General/About/Name), will NOT be recognized and are replaced with generic ones [eg. "iPhone"] which of course makes managing multiple device-connections ambiguous
* (c) will be addressed as soon as I get a chance, especially if this app is submitted to the App Store -gladius

[3] Documentation:
(a) above: https://developer.apple.com/documentation/multipeerconnectivity
(c) above: https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_device-information_user-assigned-device-name

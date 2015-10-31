# JMMColorSelector-Swift
A color picker for iOS written in Swift (translated from Objective-C)

#### Easy to use
The API is intended to make it really simple to use.
##### Examples
In order to show the ViewController :
 
    // In your ViewController
    let colorSelectorVC = JMMColorSelectorViewController.init(nibName: "JMMColorSelectorView", bundle: nil)
    colorSelectorVC.delegate = self
    self.presentViewController(colorSelectorVC, animated: true, completion: nil)

#### Work in progress
Things that I still gave to translate from Objective-C : 
- Saving to UserDefaults / UbiquitousStore depending on the programmer/user's choice
- Create examples
- Handle device rotation with totally smooth animations
- Add sample colors at the bottom of the view



# Table of Contents

- [AAMaterialSpinner](#section-id-4)
- [Description](#section-id-10)
- [Demonstration](#section-id-16)
- [Requirements](#section-id-26)
- [Installation](#section-id-32)
- [CocoaPods](#section-id-37)
- [Carthage](#section-id-63)
- [Manual Installation](#section-id-82)
- [Getting Started](#section-id-87)
- [Add in any UIView easily](#section-id-90)
- [Show as a presenter!](#section-id-104)
- [Contributions & License](#section-id-156)


<div id='section-id-4'/>

#AAMaterialSpinner


[![Swift 5.0](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/AAMaterialSpinner.svg)](http://cocoadocs.org/docsets/AAMaterialSpinner) [![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/EngrAhsanAli/AAMaterialSpinner.svg?branch=master)](https://travis-ci.org/EngrAhsanAli/AAMaterialSpinner) 
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg) [![CocoaPods](https://img.shields.io/cocoapods/p/AAMaterialSpinner.svg)]()
![AA-Creations](https://img.shields.io/badge/AA-Creations-green.svg)
![Country](https://img.shields.io/badge/Made%20with%20%E2%9D%A4-pakistan-green.svg)


<div id='section-id-10'/>

##Description


AAMaterialSpinner is a simple UIView to so Loader on screen easily in iOS, written in Swift 4.2.


<div id='section-id-16'/>

##Demonstration


To run the example project, clone the repo, and run `pod install` from the Example directory first.


<div id='section-id-26'/>

##Requirements

- iOS 10.0+
- Xcode 8.0+
- Swift 4.2+

<div id='section-id-32'/>

# Installation

`AAMaterialSpinner` can be installed using CocoaPods, Carthage, or manually.


<div id='section-id-37'/>

##CocoaPods

`AAMaterialSpinner` is available through [CocoaPods](http://cocoapods.org). To install CocoaPods, run:

`$ gem install cocoapods`

Then create a Podfile with the following contents:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
pod 'AAMaterialSpinner', '0.1.2'
end

```

Finally, run the following command to install it:
```
$ pod install
```



<div id='section-id-63'/>

##Carthage

To install Carthage, run (using Homebrew):
```
$ brew update
$ brew install carthage
```
Then add the following line to your Cartfile:

```
github "EngrAhsanAli/AAMaterialSpinner" "master"
```

Then import the library in all files where you use it:
```swift
import AAMaterialSpinner
```


<div id='section-id-82'/>

##Manual Installation

If you prefer not to use either of the above mentioned dependency managers, you can integrate `AAMaterialSpinner` into your project manually by adding the files contained in the Classes folder to your project.


<div id='section-id-87'/>

#Getting Started
----------

<div id='section-id-90'/>

##Add in any UIView easily

```swift
// In some UIViewController
var spinnerView: AAMaterialSpinner!
@IBOutlet weak var loadingView: UIView!


self.aa_ms = self.loadingView.addMaterialSpinner()
self.aa_ms.colorArray = [.blue, .red, .orange]
self.aa_ms.circleLayer.lineWidth = 3.0
```

<div id='section-id-104'/>

##Show as a presenter!


```swift
// In some UIViewController


let vc = aa_vc_material_spinner(size: 100)
vc.aa_ms.circleLayer.lineWidth = 2.0
vc.aa_ms.circleLayer.strokeColor = UIColor.blue.cgColor
aa_present_material_spinner()

DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
self.aa_dismiss_material_spinner()
}

```

<div id='section-id-156'/>

#Contributions & License

`AAMaterialSpinner` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

Pull requests are welcome! The best contributions will consist of substitutions or configurations for classes/methods known to block the main thread during a typical app lifecycle.

I would love to know if you are using `AAMaterialSpinner` in your app, send an email to [Engr. Ahsan Ali](mailto:hafiz.m.ahsan.ali@gmail.com)

[<p align="center"><img src="https://support.crowdin.com/assets/logos/crowdin-dark-symbol.png" data-canonical-src="https://support.crowdin.com/assets/logos/crowdin-dark-symbol.png" width="200" height="200" align="center"/></p>](https://crowdin.com)

# Crowdin iOS SDK

Crowdin iOS SDK delivers all new translations from Crowdin project to the application immediately. So there is no need to update this application via App Store to get the new version with the localization.

The SDK provides:

* Over-The-Air Content Delivery – the localized files can be sent to the application from the project whenever needed
* Real-time Preview – all the translations that are done via Editor can be shown in the application in real-time
* Screenshots – all screenshots made in the application may be automatically sent to your Crowdin project with tagged source strings

## Status

[![Cocoapods](https://img.shields.io/cocoapods/v/CrowdinSDK?logo=pods&cacheSeconds=3600)](https://cocoapods.org/pods/CrowdinSDK)
[![Cocoapods platforms](https://img.shields.io/cocoapods/p/CrowdinSDK?cacheSeconds=10000)](https://cocoapods.org/pods/CrowdinSDK)
[![GitHub Release Date](https://img.shields.io/github/release-date/crowdin/mobile-sdk-ios?cacheSeconds=10000)](https://github.com/crowdin/mobile-sdk-ios/releases/latest)
[![GitHub contributors](https://img.shields.io/github/contributors/crowdin/mobile-sdk-ios?cacheSeconds=3600)](https://github.com/crowdin/mobile-sdk-ios/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/crowdin/mobile-sdk-ios?cacheSeconds=3600)](https://github.com/crowdin/mobile-sdk-ios/issues)
[![GitHub License](https://img.shields.io/github/license/crowdin/mobile-sdk-ios?cacheSeconds=3600)](https://github.com/crowdin/mobile-sdk-ios/blob/master/LICENSE)

[![Azure DevOps builds (branch)](https://img.shields.io/azure-devops/build/crowdin/mobile-sdk-ios/14/master?logo=azure-pipelines&cacheSeconds=800)](https://dev.azure.com/crowdin/mobile-sdk-ios/_build/latest?definitionId=14&branchName=master)
[![codecov](https://codecov.io/gh/crowdin/mobile-sdk-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/crowdin/mobile-sdk-ios)
[![Azure DevOps tests (branch)](https://img.shields.io/azure-devops/tests/crowdin/mobile-sdk-ios/14/master?cacheSeconds=800)](https://dev.azure.com/crowdin/mobile-sdk-ios/_build/latest?definitionId=14&branchName=master)

## Table of Contents
* [Requirements](#requirements)
* [Dependencies](#dependencies)
* [Installation](#installation)
* [Setup](#setup)
* [Advanced Features](#advanced-features)
  * [Real-Time Preview](#real-time-preview)
  * [Screenshots](#screenshots)
* [Notes](#notes)
* [File Export Patterns](#file-export-patterns)
* [Contribution](#contribution)
* [Seeking Assistance](#seeking-assistance)
* [Security](#security)
* [Author](#author)
* [License](#license)

## Requirements

* Xcode 10.2 
* Swift 4.2 
* iOS 9.0

## Dependencies

* [Starscream](https://github.com/daltoniam/Starscream) - Websockets in swift for iOS and OSX.

## Installation

1. Cocoapods

   To install Crowdin iOS SDK via [cocoapods](https://cocoapods.org), make sure you have cocoapods installed locally. If not, install it with following command: ```sudo gem install cocoapods```.

   Detailed instruction can be found [here](https://guides.cocoapods.org/using/getting-started.html).

    Add the following line to your Podfile:

   ```swift
   pod 'CrowdinSDK'
   ```

2. Cocoapods spec repository:

   ```swift
   target 'MyApp' do
     pod 'CrowdinSDK'
   end
   ```

After you've added *CrowdinSDK* to your Podfile, run ```pod install``` in your project directory, open `App.xcworkspace` and build it.

## Setup

To configure iOS SDK integration you need to:

- Set up Distribution in Crowdin.
- Set up SDK and enable Over-The-Air Content Delivery feature.

**Distribution** is a CDN vault that mirrors the translated content of your project and is required for integration with iOS app.

To manage distributions open the needed project and go to *Over-The-Air Content Delivery*. You can create as many distributions as you need and choose different files for each. You’ll need to click the *Release* button next to the necessary distribution every time you want to send new translations to the app.

1. Enable *Over-The-Air Content Delivery* in your Crowdin project so that application can pull translations from CDN vault.

2. In order to start using *CrowdinSDK* you need to initialize it in *AppDelegate* or in *Info.plist*

### Setup with AppDelegate

Open *AppDelegate.swift* file and add:

   ```swift
   import CrowdinSDK
   ```

3. In `application` method add:

    ```swift
    let crowdinProviderConfig = CrowdinProviderConfig(hashString: "{your_distribution_hash}",
      localizations: [{target_languages}],
      sourceLanguage: {source_language})

    CrowdinSDK.startWithConfig(crowdinSDKConfig) // required
    ```

   `your_distribution_hash` - unique hash which you can get by going to **Over-The-Air Content Delivery** in your project settings. To see the distribution hash open the needed distribution, choose **Edit** and copy distribution hash.

   `target_languages` - target languages are the ones you’re translating to. Example: `"fr","uk","de"`

   `source_language` - source language in your Crowdin project. Example - `"en"`. Required for Screenshots and Real-Time Preview features.

   <details>
   <summary>Objective-C</summary>

   In *AppDelegate.m* add:

   ```objective-c
   @import CrowdinSDK
   ```

   or

   ```objective-c
   #import<CrowdinSDK/CrowdinSDK.h>
   ```

   In `application` method add:

   ```objective-c
   CrowdinProviderConfig *crowdinProviderConfig = [[CrowdinProviderConfig alloc] initWithHashString:@"" localizations:@[] sourceLanguage:@""];
   CrowdinSDKConfig *config = [[[CrowdinSDKConfig config] withCrowdinProviderConfig:crowdinProviderConfig]];

   [CrowdinSDK startWithConfig:config];
   ```

   If you have pure Objective-C project, then you will need to do some additional steps:

   Add the following code to your Library Search Paths:

   ```objective-c
   $(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)
   ```

   Add ```use_frameworks!``` to your Podfile.

   </details>

### Setup with Info.plist

Open *Info.plist* file and add:

`CrowdinDistributionHash` - Crowdin CDN hash value for current project (String value).

`CrowdinLocalizations` - Supported localizations for current project on crowdin server (Array of strings).

`CrowdinSourceLanguage` - Source language for current project on crowdin server (String value).

In AppDelegate you should call start method: `CrowdinSDK.start()` for Swift, and `[CrowdinSDK start]` for Objective-C.

Please note: using this setup method you will unable to set up additional *Screenshots* and *Real-Time Preview* project features.
 
### Example Project

To run the example project, first clone the repo and run `pod install` from the Example directory. All functionality described in this [article](https://github.com/crowdin/mobile-sdk-ios/wiki/Test-Application).

## Advanced Features
### Real-Time Preview

This feature allows translators to see translations in the application in real-time. It can also be used by managers and QA team to preview translations before release.

Add the below code to your *Podfile*:

```swift
use_frameworks!
target 'your-app' do
  pod 'CrowdinSDK'
  pod 'CrowdinSDK/Login'
  pod 'CrowdinSDK/RealtimeUpdate'
end
```

Open *AppDelegate.swift* file and in `application` method add:

```swift
let crowdinProviderConfig = CrowdinProviderConfig(hashString: "{your_distribution_hash}",
    localizations: [{target_languages}],
    sourceLanguage: "{source_language}")

let loginConfig = CrowdinLoginConfig(clientId: "client_id", // required for real-time preview
    clientSecret: "client_secret",
    scope: "project.screenshot",
    redirectURI: "redirectURI",
    organizationName: "organization_name")

let crowdinSDKConfig = CrowdinSDKConfig.config().with(crowdinProviderConfig: crowdinProviderConfig)
    .with(loginConfig: loginConfig) // required for screenshots and real-time preview
    .with(settingsEnabled: true) // optional: to add ‘settings’ button
    .with(realtimeUpdatesEnabled: true) // optional: to add button for real-time preview

CrowdinSDK.startWithConfig(crowdinSDKConfig) // required
```

`client_id`, `client_secret` - Crowdin OAuth Client ID and Client Secret.

`scope` - defines the access for personal tokens.

`settingsEnabled` - enable floating settings view with a list of all active features and its statuses.

`realtimeUpdatesEnabled` - enable Real-Time Preview feature.

`redirectURI` - a custom URL for your app. Read more in the [article](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).

`organizationName` - organization domain name (for Crowdin Enterprise users only).

### Screenshots

Enable if you want all the screenshots made in the application to be automatically sent to your Crowdin project with tagged strings. This will provide additional context for translators.

Add the below code to your *Podfile*:

```swift
use_frameworks!
target 'your-app' do
  pod 'CrowdinSDK'
  pod 'CrowdinSDK/Login'
  pod 'CrowdinSDK/Screenshots' // required for screenshots
  pod 'CrowdinSDK/Settings' // optional: to add ‘settings’ button
end
```

Open *AppDelegate.swift* file and in `application` method add:

```swift
let crowdinProviderConfig = CrowdinProviderConfig(hashString: "{your_distribution_hash}",
    localizations: [{target_languages}],
    sourceLanguage: "{source_language}")

let loginConfig = CrowdinLoginConfig(clientId: "client_id", // required for screenshots
    clientSecret: "client_secret",
    scope: "project.screenshot",
    redirectURI: "redirectURI",
    organizationName: "{organization_name}")

let crowdinSDKConfig = CrowdinSDKConfig.config().with(crowdinProviderConfig: crowdinProviderConfig)
    .with(screenshotsEnabled: true) // button for screenshots
    .with(loginConfig: loginConfig) // required for screenshots and real-time preview            
    .with(settingsEnabled: true) // optional: to add ‘settings’ button 

CrowdinSDK.startWithConfig(crowdinSDKConfig) // required
```

`client_id`, `client_secret` - Crowdin OAuth Client ID and Client Secret.

`scope` - defines the access for personal tokens.

`screenshotsEnabled` - enable floating button to send screenshots to Crowdin.

`settingsEnabled` - enable floating settings view with a list of all active features and its statuses.

`realtimeUpdatesEnabled` - enable Real-Time Preview feature.

`redirectURI` - a custom URL for your app. Read more in the [article](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).

`organizationName` - organization domain name (for Crowdin Enterprise users only).

## Notes

1. Configuring translation update interval

   Update translations in application every defined time interval. To enable this feature add pod `CrowdinSDK/IntervalUpdate` to your pod file:

   ```swift
   pod 'CrowdinSDK/IntervalUpdate'
   ```

   Then enable this option in `CrowdinSDKConfig`:

   ```swift
   ...
   .with(intervalUpdatesEnabled: true, interval: {interval})
   ...
   ```

`interval` - defines translations update time interval in seconds. Minimum allowed interval is 15 minutes.

2. Currently, Custom Languages, Dialects, and Language Mapping are not supported for iOS SDK.

## File Export Patterns

You can set file export patterns and check existing ones using *File Settings*. The following placeholders are supported for iOS integration:

<table class="table table-bordered">
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="vertical-align:middle">%language%</td>
      <td>Language name (e.g. Ukrainian)</td>
    </tr>
       <tr>
      <td style="vertical-align:middle">%locale%</td>
      <td>Locale (e.g. uk-UA)</td>
    </tr>
    <tr>
      <td style="vertical-align:middle">%locale_with_underscore%</td>
      <td>Locale (e.g. uk_UA)</td>
    </tr>
      <tr>
      <td style="vertical-align:middle">%osx_code%</td>
      <td>OS X locale identifier used to name ".lproj" directories</td>
    </tr>
    <tr>
      <td style="vertical-align:middle">%osx_locale%</td>
      <td>OS X locale used to name translation resources (e.g. uk, zh-Hans, zh_HK)</td>
    </tr>
   </tbody>
</table>

## Contribution
We are happy to accept contributions to the Crowdin iOS SDK. To contribute please do the following:
1. Fork the repository on GitHub.
2. Decide which code you want to submit. Commit your changes and push to the new branch.
3. Ensure that your code adheres to standard conventions, as used in the rest of the library.
4. Ensure that there are unit tests for your code.
5. Submit a pull request with your patch on Github.

## Seeking Assistance
If you find any problems or would like to suggest a feature, please feel free to file an issue on Github at [Issues Page](https://github.com/crowdin/mobile-sdk-ios/issues).

Need help working with Crowdin iOS SDK or have any questions?
[Contact Customer Success Service](https://crowdin.com/contacts).

## Security

Crowdin iOS SDK CDN feature is built with security in mind, which means minimal access possible from the end-user is required. 
When you decide to use Crowdin iOS SDK, please make sure you’ve made the following information accessible to your end-users.

- We use the advantages of Amazon Web Services (AWS) for our computing infrastructure. AWS has ISO 27001 certification and has completed multiple SSAE 16 audits. All the translations are stored at AWS servers.
- When you use Crowdin iOS SDK CDN – translations are uploaded to Amazon CloudFront to be delivered to the app and speed up the download. Keep in mind that your users download translations without any additional authentication.
- We use encryption to keep your data private while in transit.
- We do not store any Personally Identifiable Information (PII) about the end-user, but you can decide to develop the opt-out option inside your application to make sure your users have full control.
- The Automatic Screenshots and Real-Time Preview features are supposed to be used by the development team and translators team. Those features should not be compiled to the production version of your app. Therefore, should not affect end-users privacy anyhow. 

## Author

Serhii Londar, serhii.londar@gmail.com

## License
<pre>
Copyright © 2020 Crowdin

The Crowdin iOS SDK is licensed under the MIT License. 
See the LICENSE file distributed with this work for additional 
information regarding copyright ownership.

Except as contained in the LICENSE file, the name(s) of the above copyright 
holders shall not be used in advertising or otherwise to promote the sale, 
use or other dealings in this Software without prior written authorization.
</pre>

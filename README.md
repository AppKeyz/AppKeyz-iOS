App Keyz SDK for iOS
============

This SDK is designed to allow a developer to easily add either the App Keyz API by itself, or a suite also containing a "drop-in" authentication module.

This repository is a sample app that demonstrates all API calls as well as the authentication. Authentication module works on iPhone & iPad in either landscape or potrait.

The App Keyz SDK requires iOS 5.1+

Installation
------------

Installation consists of two different levels of SDK integration. One level contains just the API calls library, and the other also includes the authentication module.

## Installing ONLY the API Library

Add AppKeyz.h to your <Application Name>-Prefix.pch file:

```objective-C
#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import "AppKeyz.h"
#endif
```

Add the 'AppKeyz' directory into your Xcode project.

In the AppKeyz.h file, replace the sample token (on line 10) with your app token. The included token is not for production and will only work with this sample app.

```objective-c
NSString* const kAppToken = @"ci48xk6m"; //REPLACE WITH YOUR APP TOKEN
```


## Installing the App Keyz Suite with authentication module

Add the 'QuartzCore' framework to your project.

Add AppKeyz.h, AppKeyzSuite.h, AKUser.h to your <Application Name>-Prefix.pch file:

```objective-C
#ifdef __OBJC__
    #import <UIKit/UIKit.h>
    #import <Foundation/Foundation.h>
    #import "AppKeyzSuite.h"
    #import "AKUser.h"
    #import "AppKeyz.h"
#endif
```

Add the 'AppKeyz' and 'AppKeyzSuite' directories into your Xcode project.

In the AppKeyz.h file, replace the sample token (on line 10) with your app token. The included token is not for production and will only work with this sample app.

```objective-c
NSString* const kAppToken = @"ci48xk6m"; //REPLACE WITH YOUR APP TOKEN
```

In order to use the authentication module, add this code inside the 'viewDidLoad' method of your first view controller:

```objective-c
[AppKeyzSuite setRegisterFields:[NSArray arrayWithObjects:@"Age", @"Gender", nil]];
[AppKeyzSuite loadLoginScheme:self];
```

The 'setRegisterFields' method sets optional registeration fields (Age, Gender and six custom fields). The method is required but can be set as an empty array:

```objective-c
[AppKeyzSuite setRegisterFields:[NSArray arrayWithObjects:nil]];
```

Using the AppKeyz API Library only
-------

The AppKeyz library includes AFNetworing (thanks mattt) and UIDevice-with-UniqueIdentifier-for-iOS-5 (thanks gekitz).

The AppKeyz library is setup as a singleton, so you can call the API from your view controller like so:

```objective-c
[[AppKeyz shared] createPurchaseWithEmail:testEmail password:testPassword productSku:@"appkeyztest1" purchasePrice:-1 balance:-1 expiration:@""];
```

You can capture callbacks from the API inside 'consumeResponse':

```objective-c
case readpurchase:
    [responseObject objectForKey:@"productsku"]; //String
    [[responseObject objectForKey:@"purchaseprice"] floatValue]; //float
    [responseObject objectForKey:@"purchasedate"]; //String 2013-01-01 format
    [responseObject objectForKey:@"consumableid"]; //String
    [responseObject objectForKey:@"expiration"]; //String
    [[responseObject objectForKey:@"active"] boolValue]; //BOOL
    break;
```

And subscribe to NSNotificationCenter notifications in your viewControllers. For example for 'readpurchase':

```objective-C
[[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(dismiss:)
                                             name: @"AKeadpurchase"
                                           object: nil];
```

More detail can be found about each API call in the wiki article on <a href="#">using the AppKeyz API library</a>. Also a detailed explaination of each API call can be found in the <a href="#">App Keyz Client API v2.0 document</a>.

### Note: if you wish to use the AppKeyz login API, you can use the AKUser model, found in the AppKeyzSuite directory, or remove the assignments inside 'consumeUser'.


Using the AppKeyz Suite
------

The AppKeyz suite works in combination with the AppKeyz API Library mentioned in the above section.

If you follow the setup steps, your viewController will present a set of 'login or register' screens that will capture login or register details from the user and register them with the AppKeyz server, then save the details to an AKUser singleton. You may use the stock AKUser model and customize it, or replace with your own user model. Note that you'll need to replace AKUser methods in AppKeyz.m and AKiPhoneLoginRegisterVC.m.


//
//  ViewController.h
//  ShapeZap
//

//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ThemeScene.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController

@property (nonatomic, strong) NSDictionary *deviceInfo;

// UserData Passed Between Scenes

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *backgroundFileName;

@end

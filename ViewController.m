//
//  ViewController.m
//  ShapeZap
//
//  Created by Laure Linn on 3/31/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self getScreenInfo];
    
    // Configure the view.
    
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    // Set the background image
    
    self.backgroundFileName = DEFAULT_BACKGROUND;
    
    // Create and configure the scene.
    
    SKScene *scene = [ThemeScene sceneWithSize:skView.bounds.size];
    
    scene.userData = [NSMutableDictionary dictionary];
    [scene.userData setValue:self.imageType forKey:@"imageType"];
    [scene.userData setValue:self.backgroundFileName forKey:@"backgroundFileName"];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)getScreenInfo
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
    // Determine if the device has a retina display
    
    NSString *retinaDisplay = [UIScreen mainScreen].scale == 2.0f ? @"Yes" : @"No";
    
    // Set image file type
    
    if (screenHeight == 480 && [retinaDisplay isEqualToString:@"No"]) self.imageType = @"";
    else if (( screenHeight == 480 || screenHeight == 960 ) && [retinaDisplay isEqualToString:@"Yes"]) self.imageType = @"@2x";
    else if ( screenHeight == 568 || screenHeight == 1136 ) self.imageType = @"-568h@2x";
    else self.imageType = @"@2x";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //[self getDeviceInfo];
    });
}

- (NSDictionary *)getDeviceInfo
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    
    // Passing nil into dictionary leads to incomplete data in return dictionary, nil signals end of array/dictionary
    
    // NAME
    NSString *name = currentDevice.name ? currentDevice.name : @"unknown";
    
    // APP INFORMATION
    NSString *appVersion = [[NSBundle mainBundle]
                            objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] ? [[NSBundle mainBundle]
                                                                                           objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] : @"unknown";
    // HARDWARE INFORMATION
    NSString *systemName = currentDevice.systemName ? currentDevice.systemName : @"unknown";
    NSString *systemVersion = currentDevice.systemVersion ? currentDevice.systemVersion : @"unknown";
    NSString *model = currentDevice.model ? currentDevice.model : @"unknown";
    
    // HARDWARE FEATURES
    NSString *multitaskingSupported = currentDevice.multitaskingSupported ? @"Yes" : @"No";
    
    // RETINA DISPLAY
    NSString *retinaDisplay = [UIScreen mainScreen].scale == 2.0f ? @"Yes" : @"No";
    
    // RESOLUTION
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.f;
    CGSize res = CGSizeMake(bounds.size.width * scale, bounds.size.height * scale);
    
    NSString *resolution = [NSString stringWithFormat:@"%g x %g", res.width, res.height];
    if (!resolution) {
        resolution = @"unknown";
    }
    
    // LANGUAGE
    NSString *preferredLanguage = [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @"unknown";
    
    // LOCATION
    NSString *localizedModel = currentDevice.localizedModel ? currentDevice.localizedModel : @"unknown";
    NSString *countryCodeNSLocale = [[NSLocale currentLocale] localeIdentifier] ? [[NSLocale currentLocale] localeIdentifier] : @"unknown";
    
    // INTERNET
    NSString *internetConnectivityStatus = @"unknown device error";
    
    Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetConnection currentReachabilityStatus];
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            internetConnectivityStatus = @"Internet reachable via WWAN/3G";
            break;
        }
        case ReachableViaWiFi:
        {
            internetConnectivityStatus = @"Internet reachable via WIFI";
            break;
        }
        case NotReachable:
        {
            internetConnectivityStatus = @"Internet not reachable";
            break;
        }
        default:
        {
            internetConnectivityStatus = @"Unknown internet error";
            break;
        }
    }
    
    NSURL *iPURL = [NSURL URLWithString:@"http://www.dyndns.org/cgi-bin/check_ip.cgi"];
    NSString *externalIP = @"unknown";
    if (iPURL) {
        NSError *error = nil;
        NSString *theIpHtml = [NSString stringWithContentsOfURL:iPURL
                                                       encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            NSScanner *theScanner;
            NSString *text = nil;
            theScanner = [NSScanner scannerWithString:theIpHtml];
            while ([theScanner isAtEnd] == NO) {
                // find start of tag
                [theScanner scanUpToString:@"<" intoString:NULL] ;
                // find end of tag
                [theScanner scanUpToString:@">" intoString:&text] ;
                // replace the found tag with a space
                //(you can filter multi-spaces out later if you wish)
                theIpHtml = [theIpHtml stringByReplacingOccurrencesOfString:
                             [NSString stringWithFormat:@"%@>", text] withString:@" "] ;
                NSArray *ipItemsArray = [theIpHtml componentsSeparatedByString:@" "];
                NSUInteger an_Integer=[ipItemsArray indexOfObject:@"Address:"];
                externalIP =[ipItemsArray objectAtIndex: ++an_Integer];
            }
            //NSLog(@"%@",externalIP);
        } else {
            externalIP = @"unknown";
            /*NSLog(@"Oops... g %ld, %@",
                  (long)[error code],
                  [error localizedDescription]);*/
        }
    }
    
    // CELLULAR
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    NSString *radioAccessTechnology = telephonyInfo.currentRadioAccessTechnology ? telephonyInfo.currentRadioAccessTechnology : @"unknown";
    NSString *carrier = [[telephonyInfo subscriberCellularProvider] carrierName] ? [[telephonyInfo subscriberCellularProvider] carrierName] : @"unknown";
    NSString *isoCountryCode = [[telephonyInfo subscriberCellularProvider] isoCountryCode] ? [[telephonyInfo subscriberCellularProvider] isoCountryCode] : @"unknown";
    NSString *mobileCountryCode = [[telephonyInfo subscriberCellularProvider] mobileCountryCode] ? [[telephonyInfo subscriberCellularProvider] mobileCountryCode] : @"unknown";
    NSString *mobileNetworkCode = [[telephonyInfo subscriberCellularProvider] mobileNetworkCode] ? [[telephonyInfo subscriberCellularProvider] mobileNetworkCode] : @"unknown";
    
    // PRINTING
    NSString *isPrintingAvailable = [UIPrintInteractionController isPrintingAvailable] ? @"Yes" : @"No";
    
    self.deviceInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                  name, @"name",
                  appVersion, @"appVersion",
                  systemName, @"systemName",
                  systemVersion, @"systemVersion",
                  model, @"model",
                  multitaskingSupported, @"multitaskingSupported",
                  retinaDisplay, @"retinaDisplay",
                  resolution, @"resolution",
                  preferredLanguage, @"preferredLanguage",
                  localizedModel, @"localizedModel",
                  countryCodeNSLocale, @"countryCodeNSLocale",
                  externalIP, @"externalIP",
                  internetConnectivityStatus, @"internetConnectivityStatus",
                  radioAccessTechnology, @"radioAccessTechnology",
                  carrier, @"carrier",
                  isoCountryCode, @"isoCountryCode",
                  mobileCountryCode, @"mobileCountryCode",
                  mobileNetworkCode, @"mobileNetworkCode",
                  isPrintingAvailable, @"isPrinterAvailable",
                  nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.deviceInfo forKey:@"deviceInfo"];
    [defaults synchronize];
    
    return self.deviceInfo;
}

@end

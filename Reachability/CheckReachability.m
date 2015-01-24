//
//  CheckReachability.m
//  CustomClasses
//
//  Created by Laure Linn on 6/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "CheckReachability.h"

@implementation CheckReachability

static NSString *myHost = @"www.fyndher.com";
static NSString *myApp = @"Fyndher";

-(BOOL)isReachable
{
    BOOL reachable = YES;
    
    if ([self hostReachable:myHost]){
        reachable = YES;
    } else {
        reachable = NO;
        if ([self internetReachable]){
            [self displayErrorMessageWithTitle:@"Network Error" message:[myApp stringByAppendingString:@" server not reachable"] cancelButton:@"Ok"];
        } else {
            [self displayErrorMessageWithTitle:@"Network Error" message:@"No internet connection" cancelButton:@"Ok"];
        }
    }
    
    return reachable;
}

-(BOOL)internetReachable
{
    Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetConnection currentReachabilityStatus];
    
    BOOL reachable = YES;
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog(@"Internet reachable via WWAN/3G");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"Internet reachable via WIFI");
            break;
        }
        case NotReachable:
        {
            reachable = NO;
            NSLog(@"Internet not reachable");
            break;
        }
        default:
        {
            reachable = NO;
            NSLog(@"Unknown internet error");
            break;
        }
    }
    return reachable;
}

-(BOOL)hostReachable:(NSString *)myHost
{
    Reachability *myHostReachable = [Reachability reachabilityWithHostName:myHost];
    NetworkStatus netStatus = [myHostReachable currentReachabilityStatus];
    
    BOOL reachable = YES;
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSLog (@"%@",[myHost stringByAppendingString:@" reachable via WWAN/3G"]);
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog (@"%@",[myHost stringByAppendingString:@" reachable via WIFI"]);
            break;
        }
        case NotReachable:
        {
            reachable = NO;
            NSLog (@"%@",[myApp stringByAppendingString:@" server not reachable"]);
            break;
        }
        default:
        {
            reachable = NO;
            NSLog (@"%@",[@"Unknown error with " stringByAppendingString:myHost]);
            break;
        }

    }
    return reachable;
}

-(void)displayErrorMessageWithTitle:(NSString *)messageTitle message:(NSString *)message cancelButton:(NSString *)cancelButton
{
    NSLog (@"%@",message);
    
    UIAlertView *errorView = [[UIAlertView alloc]
                              initWithTitle: messageTitle
                              message: message
                              delegate: self
                              cancelButtonTitle: cancelButton otherButtonTitles: nil];
    [errorView show];
}

@end

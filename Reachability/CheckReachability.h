//
//  CheckReachability.h
//  CustomClasses
//
//  Created by Laure Linn on 6/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface CheckReachability : NSObject

-(BOOL)isReachable;
-(BOOL)internetReachable;
-(BOOL)hostReachable:(NSString *) myHost;
-(void)displayErrorMessageWithTitle:(NSString *)messageTitle message:(NSString *)message cancelButton:(NSString *)cancelButton;
@end

/*  CheckReachability Install Instructions
 
 1. Add SystemConfiguration.framework to project (build phases, link binary)
 
 2. Add these files to the BaseClass group
    Reachability.h
    Reachability.m
    CheckReachability.h
    CheckReachability.m
 
 3. In CheckReachability.m, update host URL and app name static variables
    static NSString *myHost = @"www.fyndher.com";
    static NSString *myApp = @"Fyndher";
 
 4. Add to viewController.h
    #Import "CheckReachability.h"
    @property (nonatomic) CheckReachability *myHost;
 
 5. Add to viewController.m
    @synthesize myHost;
 
 6. Add method to viewController.m
    -(BOOL)hostReachable
    {
        if(self.myHost == nil){
            self.myHost =  [[CheckReachability alloc] init];
    }
        return [self.myHost isReachable];
    }
 
 7. On connection or web services error call
    [self hostReachable]
 
    If the host is not reachable, this method will display the appropriate error message to the user
 Server Not Reachable, or No Internet Connection
    If host is reachable, the user isn't bothered with a message
 
 8. Check the return status of [self hostReachable];
    If hostReachable returns = YES, retry the request
    If hostReachable returns = NO, implementation your own code to handle lack of connectivity
 
 */


//
//  Game.h
//  ShapeZap
//
//  Created by Laure Linn on 2/25/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "Constants.h"

@interface Game : NSObject

// Determines correct background image for screen type
+ (NSString *)getBackgroundImage:(NSString *)imageName forScreenType:(NSString *)screenType;

// Checks for existence of files in bundle
+ (BOOL)fileExistsInBundle:(NSString *)fileName ofType:(NSString *)fileType;

// Gets random number for a range
+ (NSInteger)getRandomNumberWithMin:(NSInteger)min andMax:(NSInteger)max;


@end

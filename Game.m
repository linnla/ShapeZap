//
//  Game.m
//  ShapeZap
//
//  Created by Laure Linn on 2/25/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "Game.h"

@implementation Game

// Background Image

+ (NSString *)getBackgroundImage:(NSString *)imageName forScreenType:(NSString *)screenType
{
    //NSLog(@"Game getBackgroundImage");
    
    NSString *backgroundImage = nil;
    BOOL highResImage = NO;
    NSString *substring = [imageName substringFromIndex:[imageName length] - 3];
    
    if ([substring isEqualToString:@"@2x"]) highResImage = YES;
    
    // If the image isn't high resolution and the screen supports high resolution images, change image filename to high resolution version
    
    if (highResImage == NO &&
        ([screenType isEqualToString:@"@2x"] ||
         [screenType isEqualToString:@"-568h@2x"])) {
            
            backgroundImage = [imageName stringByAppendingString:screenType];
        }
    
    // If image exists, use it or else use resolution specific default background image
    
    if (![Game fileExistsInBundle:backgroundImage ofType:@"png"]) {
        
        backgroundImage = DEFAULT_BACKGROUND;
        
        if ([screenType isEqualToString:@"@2x"] ||
            [screenType isEqualToString:@"-568h@2x"]) {
            
            backgroundImage = [backgroundImage stringByAppendingString:screenType];
        }
    }
    
    return backgroundImage;
}

+ (BOOL)fileExistsInBundle:(NSString *)fileName ofType:(NSString *)fileType
{
    NSString *pathAndFileName = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName]) NSLog(@"ERROR - File not found: " @"%@", fileName);
    
    return [[NSFileManager defaultManager] fileExistsAtPath:pathAndFileName];
}

+ (NSInteger)getRandomNumberWithMin:(NSInteger)min andMax:(NSInteger)max
{
    int minimum = (int)min;
    int maximum = (int)max;
    
    int range = (maximum - minimum);
    int rand = (arc4random() % (range + 1)) + minimum;
    
    NSInteger randomNumber = rand;
    
    return randomNumber;
}

@end

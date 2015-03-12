//
//  BaseScene.m
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "BaseScene.h"

@implementation BaseScene

- (void)createBackgroundWithImageName:(NSString *)imageName forScreenType:(NSString *)screenType {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Get correct image for the screen resolution
    
    NSString *backgroundImage = [Game getBackgroundImage:imageName forScreenType:screenType];
    
    // Create sprite
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:[backgroundImage stringByAppendingString:@".png"]];
    background.name = @"background";
    
    // Set sprite position
    
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.zPosition = 0;
    
    // Add sprite to scene
    
    [self addChild:background];
    
    NSLog(@"Background created: %@", backgroundImage);
}

- (void)createGameLogo {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([Game fileExistsInBundle:GAMELOGO ofType:@"png"]) {
        
        SKSpriteNode *gameLogo = [SKSpriteNode spriteNodeWithImageNamed:GAMELOGO];
        
        gameLogo.xScale = 0.5;
        gameLogo.yScale = 0.5;
        gameLogo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 50);
        gameLogo.zPosition = 1;
        
        gameLogo.name = @"gameLogo";
        
        [self addChild:gameLogo];
    }
}

@end

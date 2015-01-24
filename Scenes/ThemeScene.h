//
//  ThemeScene.h
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "StartGameScene.h"
#import "Game.h"

@interface ThemeScene : SKScene

// UserData Passed Between Scenes

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *backgroundFileName;
@property (nonatomic, strong) NSString *theme;

// Sprites

@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *gameLogo;
@property (nonatomic, strong) SKSpriteNode *touchedNode;

// Arrays

@property (nonatomic, strong) NSArray *themes;


@end

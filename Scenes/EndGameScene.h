//
//  EndGameScene.h
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ThemeScene.h"
#import "StartGameScene.h"
#import "Game.h"

@interface EndGameScene : SKScene

@property BOOL win;

@property (nonatomic) SKSpriteNode *playAgainButton;
@property (nonatomic, strong) SKSpriteNode *changeThemeButton;

@property (nonatomic) NSString *gameOutcome;
@property (nonatomic) NSString *gameOverMessage1;
@property (nonatomic) NSString *gameOverMessage2;

@property (nonatomic) NSString *nextScene;

// UserData Passed Between Scenes

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *theme;
@property NSUInteger stage;

// From Theme

@property (nonatomic, strong) NSString *backgroundFileName;

// From stage JSON

//@property NSUInteger winsRequired;

// Sprites

@property (nonatomic, strong) SKSpriteNode *background;

// Score

@property double elapsedTime;
@property int hits;
@property int misses;


@end

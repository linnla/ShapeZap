//
//  StartGameScene.h
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Game.h"
#import "ViewController.h"
#import "Constants.h"

@interface StartGameScene : SKScene

// UserData Passed Between Scenes

@property (nonatomic) NSString *imageType;
@property (nonatomic) NSString *backgroundFileName;
@property (nonatomic) NSString *theme;
@property (nonatomic) NSString *hitSound;
@property (nonatomic) NSString *missSound;
@property NSUInteger stage;

// From stage JSON

@property NSUInteger spin;
@property float spriteSize;
@property float speed;
@property NSUInteger totalGameSprites;
//@property NSUInteger winsRequired;

// Sprites

@property (nonatomic, weak) SKSpriteNode *touchedNode;
@property (nonatomic, weak) SKSpriteNode *randomBackground;
@property (nonatomic, weak) SKSpriteNode *background;
@property (nonatomic, weak) SKSpriteNode *gameLogo;
@property (nonatomic, weak) SKSpriteNode *playLabel;

@property (nonatomic, weak) SKSpriteNode *sprite1;
@property (nonatomic, weak) SKSpriteNode *sprite2;
@property (nonatomic, weak) SKSpriteNode *sprite3;
@property (nonatomic, weak) SKSpriteNode *sprite4;
@property (nonatomic, weak) SKSpriteNode *sprite5;
@property (nonatomic, weak) SKSpriteNode *sprite6;
@property (nonatomic, weak) SKSpriteNode *sprite7;
@property (nonatomic, weak) SKSpriteNode *sprite8;

// Arrays

@property (nonatomic, weak) NSMutableArray *stages;
@property (nonatomic, weak) NSMutableArray *backgroundImages;

@property (nonatomic) NSMutableArray *spriteImageNames;
@property (nonatomic, weak) NSMutableArray *sprites;

// Other

@property (nonatomic, weak) NSString *scoringSprite;
@property NSUInteger stageNumber;

@end

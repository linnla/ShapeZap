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

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *backgroundFileName;
@property (nonatomic, strong) NSString *theme;
@property (nonatomic, strong) NSString *hitSound;
@property (nonatomic, strong) NSString *missSound;
@property NSUInteger stage;

// From stage JSON

@property NSUInteger spin;
@property float spriteSize;
@property float speed;
@property NSUInteger totalGameSprites;
//@property NSUInteger winsRequired;

// Sprites

// Changed from weak to strong
@property (nonatomic, strong) SKSpriteNode *touchedNode;
@property (nonatomic, strong) SKSpriteNode *randomBackground;
@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) SKSpriteNode *gameLogo;
@property (nonatomic, strong) SKSpriteNode *playLabel;

@property (nonatomic, strong) SKSpriteNode *sprite1;
@property (nonatomic, strong) SKSpriteNode *sprite2;
@property (nonatomic, strong) SKSpriteNode *sprite3;
@property (nonatomic, strong) SKSpriteNode *sprite4;
@property (nonatomic, strong) SKSpriteNode *sprite5;
@property (nonatomic, strong) SKSpriteNode *sprite6;
@property (nonatomic, strong) SKSpriteNode *sprite7;
@property (nonatomic, strong) SKSpriteNode *sprite8;

// Arrays

// Changed from weak to strong
@property (nonatomic, strong) NSMutableArray *stages;
@property (nonatomic, strong) NSMutableArray *backgroundImages;

@property (nonatomic) NSMutableArray *spriteImageNames;
@property (nonatomic, strong) NSMutableArray *sprites;

// Other

// Changed from weak to strong
@property (nonatomic, strong) NSString *scoringSprite;
@property NSUInteger stageNumber;

@end

//
//  GameScene.h
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EndGameScene.h"
#import "Constants.h"
#import <AudioToolbox/AudioToolbox.h>

@interface GameScene : SKScene

@property BOOL gameOver;

// UserData Passed Between Scenes

@property (nonatomic, strong) NSString *imageType;
@property (nonatomic, strong) NSString *theme;
@property NSUInteger stage;

// From Theme

@property (nonatomic, strong) NSString *backgroundFileName;
@property (nonatomic, strong) NSString *hitSound;
@property (nonatomic, strong) NSString *missSound;

// From stage JSON

@property NSUInteger spin;
@property float spriteSize;
@property float speed;
@property NSUInteger totalGameSprites;
//@property NSUInteger winsRequired;

// Sprites

@property (nonatomic, strong) SKSpriteNode *background;

// Arrays

@property (nonatomic, strong) NSMutableArray *spriteImageNames;
@property (nonatomic, strong) NSMutableArray *sprites;

// Other

@property (nonatomic, strong) NSString *scoringSprite;

// Time

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) CFTimeInterval spawnTimeIntervalForLevel;
@property (nonatomic) NSInteger spritesPerSecond;
@property double startTime;
@property double elapsedTime;
@property double timeRemaining;
@property float spriteSeconds;

// Timer textures

@property (nonatomic, strong) SKTextureAtlas *timerTextureAtlas;
@property (nonatomic, strong) SKSpriteNode *progressTimer;
@property (nonatomic, strong) NSArray *timerTextures;

@property (nonatomic, strong) SKTexture *timer0;
@property (nonatomic, strong) SKTexture *timer1;
@property (nonatomic, strong) SKTexture *timer2;
@property (nonatomic, strong) SKTexture *timer3;
@property (nonatomic, strong) SKTexture *timer4;
@property (nonatomic, strong) SKTexture *timer5;
@property (nonatomic, strong) SKTexture *timer6;
@property (nonatomic, strong) SKTexture *timer7;
@property (nonatomic, strong) SKTexture *timer8;
@property (nonatomic, strong) SKTexture *timer9;
@property (nonatomic, strong) SKTexture *timer10;
@property (nonatomic, strong) SKTexture *timer11;
@property (nonatomic, strong) SKTexture *timer12;
@property (nonatomic, strong) SKTexture *timer13;
@property (nonatomic, strong) SKTexture *timer14;
@property (nonatomic, strong) SKTexture *timer15;
@property (nonatomic, strong) SKTexture *timer16;
@property (nonatomic, strong) SKTexture *timer17;
@property (nonatomic, strong) SKTexture *timer18;
@property (nonatomic, strong) SKTexture *timer19;
@property (nonatomic, strong) SKTexture *timer20;

// Scoring

@property int hits;
@property int misses;

@property (nonatomic) SKSpriteNode *hitScore;
@property (nonatomic) SKSpriteNode *missScore;

// Explosion textures

@property (nonatomic) SKTextureAtlas *explosionTextureAtlas;

@property (nonatomic) NSArray *explosionTextures;
@property (nonatomic) NSArray *firstExplosionTexture;
@property (nonatomic) NSArray *missTexture;

@property (nonatomic) SKTexture *explosion;
@property (nonatomic) SKTexture *x;

@property (nonatomic) SKTexture *explosion0;
@property (nonatomic) SKTexture *explosion1;
@property (nonatomic) SKTexture *explosion2;
@property (nonatomic) SKTexture *explosion3;
@property (nonatomic) SKTexture *explosion4;
@property (nonatomic) SKTexture *explosion5;
@property (nonatomic) SKTexture *explosion6;
@property (nonatomic) SKTexture *explosion7;

// Actions

@property (nonatomic) SKAction *explosionAction;
@property (nonatomic) SKAction *missAction;

@end

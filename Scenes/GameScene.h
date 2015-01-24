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

@property (nonatomic) NSString *imageType;
@property (nonatomic) NSString *theme;
@property NSUInteger stage;

// From Theme

@property (nonatomic) NSString *backgroundFileName;
@property (nonatomic) NSString *hitSound;
@property (nonatomic) NSString *missSound;

// From stage JSON

@property NSUInteger spin;
@property float spriteSize;
@property float speed;
@property NSUInteger totalGameSprites;
//@property NSUInteger winsRequired;

// Sprites

@property (nonatomic, strong) SKSpriteNode *background;

// Arrays

@property (nonatomic) NSMutableArray *spriteImageNames;
@property (nonatomic) NSMutableArray *sprites;

// Other

@property (nonatomic) NSString *scoringSprite;

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

@property (nonatomic) SKTextureAtlas *timerTextureAtlas;
@property (nonatomic) SKSpriteNode *progressTimer;
@property (nonatomic) NSArray *timerTextures;

@property (nonatomic) SKTexture *timer0;
@property (nonatomic) SKTexture *timer1;
@property (nonatomic) SKTexture *timer2;
@property (nonatomic) SKTexture *timer3;
@property (nonatomic) SKTexture *timer4;
@property (nonatomic) SKTexture *timer5;
@property (nonatomic) SKTexture *timer6;
@property (nonatomic) SKTexture *timer7;
@property (nonatomic) SKTexture *timer8;
@property (nonatomic) SKTexture *timer9;
@property (nonatomic) SKTexture *timer10;
@property (nonatomic) SKTexture *timer11;
@property (nonatomic) SKTexture *timer12;
@property (nonatomic) SKTexture *timer13;
@property (nonatomic) SKTexture *timer14;
@property (nonatomic) SKTexture *timer15;
@property (nonatomic) SKTexture *timer16;
@property (nonatomic) SKTexture *timer17;
@property (nonatomic) SKTexture *timer18;
@property (nonatomic) SKTexture *timer19;
@property (nonatomic) SKTexture *timer20;

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

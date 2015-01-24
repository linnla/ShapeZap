//
//  GameScene.m
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    self.imageType = [self.userData valueForKey:@"imageType"];
    self.backgroundFileName = [self.userData objectForKey:@"backgroundFileName"];
    self.theme = [self.userData valueForKey:@"theme"];
    self.missSound = [self.userData valueForKey:@"missSound"];
    self.hitSound = [self.userData valueForKey:@"hitSound"];
    //self.sprites = [self.userData objectForKey:@"sprites"];
    self.spriteImageNames = [self.userData objectForKey:@"spriteImageNames"];
    self.scoringSprite = [self.userData valueForKey:@"scoringSprite"];
    
    self.stage = [[self.userData valueForKey:@"stage"] integerValue];
    self.spriteSize = [[self.userData valueForKey:@"spriteSize"] floatValue];
    self.speed = [[self.userData valueForKey:@"speed"] floatValue];
    self.spin = [[self.userData valueForKey:@"spin"] integerValue];
    self.totalGameSprites = [[self.userData valueForKey:@"totalGameSprites"] integerValue];
    //self.winsRequired = [[self.userData valueForKey:@"winsRequired"] integerValue];
    
    self.hits = 0;
    self.misses = 0;
    self.gameOver = NO;
    
    //NSLog(@"ImageType is : %@",self.imageType);
    //NSLog(@"Background is : %@",self.backgroundFileName);
    //NSLog(@"Theme is : %@",self.theme);
    //NSLog(@"Scoring sprite is : %@",self.scoringSprite);
    
    //NSLog(@"Stage is : %lu",(unsigned long)self.stage);
    //NSLog(@"Sprite size is : %f",self.spriteSize);
    //NSLog(@"Speed is : %f",self.speed);
    //NSLog(@"Spin is : %lu",(unsigned long)self.spin);
    //NSLog(@"Total Game Sprite are : %lu",(unsigned long)self.totalGameSprites);
    //NSLog(@"Wins required is : %lu",(unsigned long)self.winsRequired);
    
    [self createBackgroundWithImageName:self.backgroundFileName forScreenType:self.imageType];
    
    [self setPhysics];
    
    [self createTimerTextures];
    //[self preloadTimerTextures];
    
    // Add Score Labels
    
    [self createMissLabels];
    [self createMissScore];
    
    [self createHitLabels];
    [self createHitScore];
    
    //[self preloadExplosionTextures];
    //[self preLoadMissTexture];
    
    // Preload Actions
    
    [self preloadExplosionAction];
    [self preloadMissAction];
    
    self.spritesPerSecond = self.totalGameSprites / GAMETIME;
    
    // This is the rate of how many sprites must be created each second to load totalGameSprites in GAMETIME
    
    self.spriteSeconds = 1 / (float)self.spritesPerSecond;
    
    if (self.physicsWorld.gravity.dy == 0) {
        self.totalGameSprites = self.totalGameSprites * .20;
    }
    
    // Start Timer
    
    self.startTime = CACurrentMediaTime();
    [self startTimer];
    
    //[self vibrate];
}

- (void)setPhysics
{
    NSArray *gravityArray = @[@"0", @"1", @"-1"];
    NSString *gravityString_dy = gravityArray[arc4random_uniform([gravityArray count])];
    
    self.physicsWorld.gravity = CGVectorMake(0, [gravityString_dy floatValue]);
    self.physicsWorld.speed = self.speed;
    
    //NSLog(@"self.physicsWorld.gravity.dy = %f", self.physicsWorld.gravity.dy);
    
    if (self.physicsWorld.gravity.dy == 0)
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetMinX(self.frame) - 100,
                                                                              CGRectGetMinY(self.frame) - 100,
                                                                              CGRectGetMaxX(self.frame) + 200,
                                                                              CGRectGetMaxY(self.frame) + 200)];
}

- (void)startTimer
{
    if (self.timerTextures.count > 0) {
        
        self.progressTimer = [SKSpriteNode spriteNodeWithTexture:self.timer20];
        
        self.progressTimer.name = @"progressTimer";
        self.progressTimer.xScale = 1.0;
        self.progressTimer.yScale = 1.0;
        
        self.progressTimer.position = CGPointMake(CGRectGetMaxX(self.frame) - 30, CGRectGetMaxY(self.frame) - 45);
        [self addChild:self.progressTimer];
        
        SKAction *animate = [SKAction animateWithTextures:self.timerTextures timePerFrame:1.0];
        [self.progressTimer runAction: animate];
        
        //NSLog(@"Timer Started");
        
    } else {
        
        NSLog(@"ERROR - self.timeTexture.count = 0");
    }
}

- (void)endGame
{
    //NSLog(@"endGame : %d", self.gameOver);
    [self changeScene];
}

- (void)changeScene
{
    SKView *spriteView = (SKView *) self.view;
    SKScene *scene = [[EndGameScene alloc] initWithSize:self.size];
    
    scene.userData = [NSMutableDictionary dictionary];
    
    [scene.userData setValue:self.backgroundFileName forKey:@"backgroundFileName"];
    [scene.userData setValue:self.imageType forKey:@"imageType"];
    [scene.userData setValue:self.theme forKey:@"theme"];
    
    NSString *stageNumberString = [NSString stringWithFormat:@"%d", self.stage];
    [scene.userData setValue:stageNumberString forKey:@"stage"];
    
    //NSString *winsRequiredString = [NSString stringWithFormat:@"%d", self.winsRequired];
    //[scene.userData setValue:winsRequiredString forKey:@"winsRequired"];
    
    NSString *hitsString = [NSString stringWithFormat:@"%d", self.hits];
    [scene.userData setValue:hitsString forKey:@"hits"];
    
    NSString *missesString = [NSString stringWithFormat:@"%d", self.misses];
    [scene.userData setValue:missesString forKey:@"misses"];
    
    NSString *elapsedTimeString = [NSString stringWithFormat:@"%.2f", -self.elapsedTime];
    [scene.userData setValue:elapsedTimeString forKey:@"elapsedTime"];
    
    [self removeAllActions];
    [self.background removeFromParent];
    [self.progressTimer removeFromParent];
    //[self.hitLabel removeFromParent];
    [self.hitScore removeFromParent];
    //[self.missLabel removeFromParent];
    [self.missScore removeFromParent];
    
    [self enumerateChildNodesWithName:@"//*" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    /*[self enumerateChildNodesWithName:@"explosionSprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];*/
    
    [self enumerateChildNodesWithName:@"gameSprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"scoringSprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];

    SKTransition *fade = [SKTransition fadeWithDuration:.50];
    [spriteView presentScene:scene transition:fade];

}

- (void)createBackgroundWithImageName:(NSString *)imageName forScreenType:(NSString *)screenType
{
    // Get correct image for the screen resolution
    NSString *backgroundImage = [Game getBackgroundImage:imageName forScreenType:screenType];
    
    // Create sprite
    self.background = [SKSpriteNode spriteNodeWithImageNamed:[backgroundImage stringByAppendingString:@".png"]];
    self.background.name = @"background";
    
    // Set sprite position
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.background.zPosition = 0;
    
    // Add sprite to scene
    [self addChild:self.background];
}

- (void)update:(NSTimeInterval)currentTime
{
    // Handle time delta (Apple code)
    // If we drop below 60fps, we still want everything to move the same distance.
    
    //[self isGameOver];
    
    if (-self.elapsedTime >= GAMETIME) {
        self.gameOver = YES;
        [self endGame];
    }
    
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
}


- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    
    self.lastSpawnTimeInterval += timeSinceLast;
    
    if (self.lastSpawnTimeInterval > self.spriteSeconds) {
        
        self.lastSpawnTimeInterval = 0;
        
        if (self.progressTimer) [self createRandomGameSprite];
        
    }
    
    self.elapsedTime = self.startTime - CACurrentMediaTime();
    self.elapsedTime = self.startTime - CACurrentMediaTime();
    self.timeRemaining = GAMETIME + self.elapsedTime;
    
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //NSLog(@"Touched node is: %@", touchedNode.name);
    
    if ([touchedNode.name isEqualToString:@"scoringSprite"]) {
        
        //[self vibrate];
        
        //[touchedNode removeFromParent];
        
        //SKSpriteNode *explosionSprite = [SKSpriteNode spriteNodeWithTexture:self.explosion];
        /*SKSpriteNode *explosionSprite = [SKSpriteNode spriteNodeWithImageNamed:@"explode"];
        explosionSprite.name = @"explosionSprite";
        explosionSprite.xScale = 1.0;
        explosionSprite.yScale = 1.0;
        explosionSprite.position = touchLocation;
        [self addChild:explosionSprite];*/
        
        //[explosionSprite runAction: self.explosionAction];
        
        [touchedNode runAction: self.explosionAction];
        
        [self hit];
        
    } else {
        
        if (![touchedNode.name isEqualToString:@"background"]) [touchedNode removeFromParent];
        
        SKSpriteNode *xSprite = [SKSpriteNode spriteNodeWithTexture:self.x];
        xSprite.xScale = .5;
        xSprite.yScale = .5;
        xSprite.name = @"xSprite";
        xSprite.position = touchLocation;
        [self addChild:xSprite];
        
        [xSprite runAction: self.missAction];
        
        [self miss];
    }
}

- (void)hit
{
    self.hits += 1;
    
    if (self.hits >= SCORE_HITS_REQUIRED) {
        self.gameOver = YES;
        [self endGame];
        return;
    }
    
    if (self.hitScore) {
        
        [self.hitScore removeFromParent];
        
        if (self.hits <= 0) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"0@2x"]];
        else if (self.hits == 1) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"1@2x"]];
        else if (self.hits == 2) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"2@2x"]];
        else if (self.hits == 3) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"3@2x"]];
        else if (self.hits == 4) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"4@2x"]];
        else if (self.hits == 5) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"5@2x"]];
        else if (self.hits == 6) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"6@2x"]];
        else if (self.hits == 7) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"7@2x"]];
        else if (self.hits == 8) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"8@2x"]];
        else if (self.hits == 9) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"9@2x"]];
        else if (self.hits >= 10) self.hitScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"10@2x"]];
        
        self.hitScore.xScale = .45;
        self.hitScore.yScale = .45;
        
        self.hitScore.name = @"hitScore";
        
        float hit_x = CGRectGetMidX(self.frame);
        float hitScore_y = CGRectGetMaxY(self.frame) - 60;
        
        self.hitScore.position = CGPointMake(hit_x, hitScore_y);
        self.hitScore.zPosition = 10;
        
        [self addChild:self.hitScore];
    }
}

- (void)miss
{
    self.misses += 1;
    
    if (self.misses >= SCORE_MISSES_ALLOWED) {
        self.gameOver = YES;
        [self endGame];
        return;
    }
    
    if (self.missScore) {
        
        [self.missScore removeFromParent];
        
        if (self.misses == 0) {
            self.missScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"miss0@2x"]];
        } else if (self.misses == 1) {
            self.missScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"miss1@2x"]];
        } else if (self.misses == 2) {
            self.missScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"miss2@2x"]];
        } else if (self.misses >= 3) {
            self.missScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"miss3@2x"]];
        }
        
        self.missScore.xScale = .45;
        self.missScore.yScale = .45;
        
        self.missScore.name = @"missScore";
        
        float miss_x = CGRectGetMinX(self.frame) + 40;
        float miss_y = CGRectGetMaxY(self.frame) - 60;
        
        self.missScore.position = CGPointMake(miss_x, miss_y);
        
        [self addChild:self.missScore];
    }
}


/*
 AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
 AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
 
 Both the functions vibrate the iPhone. But when you use the first function on devices that don’t support vibration,
 it plays a beep sound. The second function on the other hand does nothing on unsupported devices.
 
 */

- (void)vibrate {
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)createRandomGameSprite
{
    // Make sure spriteImageNames array has imageNames
    
    if ((self.spriteImageNames.count == 0) || self.spriteImageNames == nil) {
         NSLog(@"ERROR - self.sprites.count == 0 OR self.sprite = nil");
        return;
    }
    
    // Select a random imageName from sprite imageName array set the sprite name to either scoringSprite or gameSprite
    
    NSString *spriteName;
    
    NSString *randomSpriteImage = self.spriteImageNames[arc4random_uniform([self.spriteImageNames count])];
    if ([randomSpriteImage isEqualToString:self.scoringSprite]) spriteName = @"scoringSprite";
    else spriteName = @"gameSprite";
    
    // If the screen is a high resolution screen, check self.imageType, use the @2x sprite image and scale it down with the imageAdjustment float
    
    float imageAdjustment;
    
    if ([self.imageType isEqualToString:@"@2x"] || [self.imageType isEqualToString:@"-568h@2x"]) {
        randomSpriteImage = [randomSpriteImage stringByAppendingString:@"@2x"];
        imageAdjustment = .50;
    } else {
        imageAdjustment = 1.0;
    }

    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:randomSpriteImage];
    sprite.name = spriteName;
    
    if ([spriteName isEqualToString:@"scoringSprite"]) {
        //NSLog(@"Image name is: %@", randomSpriteImage);
        //NSLog(@"Sprite name is: %@", spriteName);
        //NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }
    
    //NSLog(@"Image name is: %@", randomSpriteImage);
    //NSLog(@"Sprite name is: %@", spriteName);
    //NSLog(@"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    
    // Set size
    
    sprite.yScale = self.spriteSize * imageAdjustment;
    sprite.xScale = self.spriteSize * imageAdjustment;
    
    if (self.physicsWorld.gravity.dy == 0) {
        
        sprite.yScale = (self.spriteSize * imageAdjustment) * .833;
        sprite.xScale = (self.spriteSize * imageAdjustment) * .833;
        
    } else {
        
        sprite.yScale = self.spriteSize * imageAdjustment;
        sprite.xScale = self.spriteSize * imageAdjustment;
    }
    
    // Set spin
    
    sprite.zRotation = self.spin;
    
    if (self.spin == 1) {
        SKAction *action = [SKAction rotateByAngle:M_PI duration:.75];
        [sprite runAction:[SKAction repeatActionForever:action]];
    }

    // Set position
    
    // Determine where to spawn the monster along the Y axis
    
    // Create the sprite slightly off-screen along the edges
    // Spawn sprite from a random location off-screen
    // Off-screen position is based on gravity.dy
    
    float x = CGRectGetMidX(self.frame);
    float y = CGRectGetMidY(self.frame);
    
    float min_x = CGRectGetMinX(self.frame);
    float max_x = CGRectGetMaxX(self.frame);
    float min_y = CGRectGetMinY(self.frame);
    float max_y = CGRectGetMaxY(self.frame);
    
    float startOffScreen = 100;
    
    if (self.physicsWorld.gravity.dy == 0) {
        
        NSArray *zeroGravityScenario = @[@"1", @"2", @"3", @"4"];
        
        NSString *startScenario = zeroGravityScenario[arc4random_uniform([zeroGravityScenario count])];
        
        if ([startScenario isEqualToString:@"1"]) {             // ENTER FROM RIGHT
            x = CGRectGetMaxX(self.frame) + startOffScreen;
            y = [Game getRandomNumberWithMin: CGRectGetMinY(self.frame) andMax:CGRectGetMaxY(self.frame)];
            
        } else if ([startScenario isEqualToString:@"2"]) {      // ENTER FROM TOP
            y = CGRectGetMaxY(self.frame) + startOffScreen;
            x = [Game getRandomNumberWithMin: CGRectGetMinX(self.frame) andMax:CGRectGetMaxX(self.frame)];
            
        } else if ([startScenario isEqualToString:@"3"]) {      // ENTER FROM LEFT
            x = CGRectGetMinX(self.frame) - startOffScreen;
            y = [Game getRandomNumberWithMin: CGRectGetMinY(self.frame) andMax:CGRectGetMaxY(self.frame)];
            
        } else if ([startScenario isEqualToString:@"4"]) {      // ENTER FROM BOTTOM
            y = CGRectGetMinY(self.frame) - startOffScreen;
            x = [Game getRandomNumberWithMin: CGRectGetMinX(self.frame) andMax:CGRectGetMaxX(self.frame)];
        }
        
    } else if (self.physicsWorld.gravity.dy == -1) {
        
        min_x = CGRectGetMinX(self.frame);
        max_x = CGRectGetMaxX(self.frame);
        
        max_y = CGRectGetMaxY(self.frame) + (startOffScreen * .5);  // ENTER FROM TOP
        min_y = max_y;
        
        x = [Game getRandomNumberWithMin:min_x andMax:max_x];
        y = [Game getRandomNumberWithMin:min_y andMax:max_y];
        
    } else if (self.physicsWorld.gravity.dy == 1) {
        
        min_x = CGRectGetMinX(self.frame);
        max_x = CGRectGetMaxX(self.frame);
        
        min_y = CGRectGetMinY(self.frame) - (startOffScreen * .5);  // ENTER FROM BOTTOM
        max_y = min_y;
        
        x = [Game getRandomNumberWithMin:min_x andMax:max_x];
        y = [Game getRandomNumberWithMin:min_y andMax:max_y];
        
    }
    
    sprite.position = CGPointMake(x, y);
    sprite.zPosition = 1;
    
    // Set physics
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 2];
    sprite.physicsBody.affectedByGravity = DEFAULT_AFFECTEDBYGRAVITY;
    sprite.physicsBody.dynamic = DEFAULT_DYNAMIC;
    sprite.physicsBody.allowsRotation = DEFAULT_ALLOWSROTATION;
    sprite.physicsBody.friction = DEFAULT_FRICTION;
    sprite.physicsBody.linearDamping = DEFAULT_LINEARDAMPING;
    sprite.physicsBody.restitution = DEFAULT_RESTITUTION;
    
    // Add sprite to scene
    
    [self addChild:sprite];
    
    // If its zero gravity, add impluse to sprite to get it moving
    
    if (self.physicsWorld.gravity.dy == 0) {
        
        float random_x = [Game getRandomNumberWithMin:DEFAULT_VECTORIMPLUSE_MIN andMax:DEFAULT_VECTORIMPLUSE_MAX];
        float random_y = [Game getRandomNumberWithMin:DEFAULT_VECTORIMPLUSE_MIN andMax:DEFAULT_VECTORIMPLUSE_MAX];
        
        [sprite.physicsBody applyImpulse:CGVectorMake(random_x, random_y)];
    }
}

- (void)createHitLabels
{
    SKSpriteNode *hitLabel = [SKSpriteNode spriteNodeWithImageNamed:@"HitLabel@2x"];
    
    hitLabel.name = @"hitLabel";
    hitLabel.xScale = .50;
    hitLabel.yScale = .50;
    
    float hit_x = CGRectGetMidX(self.frame);
    float hitLabel_y = CGRectGetMaxY(self.frame) - 35;
    
    hitLabel.position = CGPointMake(hit_x, hitLabel_y);
    hitLabel.zPosition = 10;
    
    [self addChild:hitLabel];
}

- (void)createHitScore
{
    // Create sprite
    
    self.hitScore = [SKSpriteNode spriteNodeWithImageNamed:@"0@2x"];
    self.hitScore.xScale = .50;
    self.hitScore.yScale = .50;
    
    // Position sprite
    
    float hit_x = CGRectGetMidX(self.frame);
    float hitScore_y = CGRectGetMaxY(self.frame) - 60;
    self.hitScore.position = CGPointMake(hit_x, hitScore_y);
    self.hitScore.zPosition = 10;
    
    // Add sprite to scene
    
    [self addChild:self.hitScore];
}

- (void)createMissLabels
{
    // Create the label sprite
    
    SKSpriteNode *missLabel = [SKSpriteNode spriteNodeWithImageNamed:@"MissLabel@2x"];
    missLabel.name = @"missLabel";
    missLabel.xScale = .50;
    missLabel.yScale = .50;
    
    // Position sprite
    
    float miss_x = CGRectGetMinX(self.frame) + 40;
    float missLabel_y = CGRectGetMaxY(self.frame) - 35;
    missLabel.position = CGPointMake(miss_x, missLabel_y);
    missLabel.zPosition = 10;
    
    // Add sprite to scene
    
    [self addChild:missLabel];
}

- (void)createMissScore
{
    // Create the label sprite
    
    self.missScore = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"miss0@2x"]];
    
    // Scale score sprite
    
    self.missScore.xScale = .45;
    self.missScore.yScale = .45;
    
    self.missScore.name = @"missScore";
    
    // Position sprites
    
    float miss_x = CGRectGetMinX(self.frame) + 40;
    float missScore_y = CGRectGetMaxY(self.frame) - 60;
    self.missScore.position = CGPointMake(miss_x, missScore_y);
    self.missScore.zPosition = 10;
    
    // Add sprite to scene
    
    [self addChild:self.missScore];
}

- (void)createTimerTextures
{
    self.timerTextureAtlas = [SKTextureAtlas atlasNamed:@"timer"];
    
    self.timer20 = [self.timerTextureAtlas textureNamed:@"time_20@2x"];
    self.timer19 = [self.timerTextureAtlas textureNamed:@"time_19@2x"];
    self.timer18 = [self.timerTextureAtlas textureNamed:@"time_18@2x"];
    self.timer17 = [self.timerTextureAtlas textureNamed:@"time_17@2x"];
    self.timer16 = [self.timerTextureAtlas textureNamed:@"time_16@2x"];
    self.timer15 = [self.timerTextureAtlas textureNamed:@"time_15@2x"];
    self.timer14 = [self.timerTextureAtlas textureNamed:@"time_14@2x"];
    self.timer13 = [self.timerTextureAtlas textureNamed:@"time_13@2x"];
    self.timer12 = [self.timerTextureAtlas textureNamed:@"time_12@2x"];
    self.timer11 = [self.timerTextureAtlas textureNamed:@"time_11@2x"];
    self.timer10 = [self.timerTextureAtlas textureNamed:@"time_10@2x"];
    self.timer9  = [self.timerTextureAtlas textureNamed:@"time_09@2x"];
    self.timer8  = [self.timerTextureAtlas textureNamed:@"time_08@2x"];
    self.timer7  = [self.timerTextureAtlas textureNamed:@"time_07@2x"];
    self.timer6  = [self.timerTextureAtlas textureNamed:@"time_06@2x"];
    self.timer5  = [self.timerTextureAtlas textureNamed:@"time_05@2x"];
    self.timer4  = [self.timerTextureAtlas textureNamed:@"time_04@2x"];
    self.timer3  = [self.timerTextureAtlas textureNamed:@"time_03@2x"];
    self.timer2  = [self.timerTextureAtlas textureNamed:@"time_02@2x"];
    self.timer1  = [self.timerTextureAtlas textureNamed:@"time_01@2x"];
    self.timer0  = [self.timerTextureAtlas textureNamed:@"time_00@2x"];
    
    self.timerTextures = @[self.timer20, self.timer19, self.timer18, self.timer17, self.timer16, self.timer15, self.timer14, self.timer13, self.timer12, self.timer11, self.timer10, self.timer9, self.timer8, self.timer7, self.timer6, self.timer5, self.timer4, self.timer3, self.timer2, self.timer1, self.timer0];
}
          
- (void)didSimulatePhysics
{
    if (self.physicsWorld.gravity.dy == 0) {
        
        return;
        
    } else if (self.physicsWorld.gravity.dy > 0) {  // Gravity is positive, objects rise
        
        [self enumerateChildNodesWithName:@"gameSprite" usingBlock:^(SKNode *node, BOOL *stop) {
            if (node.position.y > CGRectGetMaxY(self.frame)) [node removeFromParent];
        }];
        
        [self enumerateChildNodesWithName:@"scoringSprite" usingBlock:^(SKNode *node, BOOL *stop) {
            if (node.position.y > CGRectGetMaxY(self.frame)) [node removeFromParent];
        }];
        
    } else {                                      // Gravity is negative, objects fall

        [self enumerateChildNodesWithName:@"gameSprite" usingBlock:^(SKNode *node, BOOL *stop) {
            if (node.position.y < CGRectGetMinY(self.frame)) [node removeFromParent];
        }];
        
        [self enumerateChildNodesWithName:@"scoringSprite" usingBlock:^(SKNode *node, BOOL *stop) {
            if (node.position.y < CGRectGetMinY(self.frame)) [node removeFromParent];
        }];
    }
}

- (void)preloadExplosionTextures
{
    self.explosion = [SKTexture textureWithImageNamed:@"explode"];
    self.firstExplosionTexture = @[self.explosion];
    
    /*self.explosionTextureAtlas = [SKTextureAtlas atlasNamed:@"explosionWhite"];
    
    self.explosion0 = [self.explosionTextureAtlas textureNamed:@"Explode_white0@2x"];
    self.explosion1 = [self.explosionTextureAtlas textureNamed:@"Explode_white1@2x"];
    self.explosion2 = [self.explosionTextureAtlas textureNamed:@"Explode_white2@2x"];
    self.explosion3 = [self.explosionTextureAtlas textureNamed:@"Explode_white3@2x"];
    self.explosion4 = [self.explosionTextureAtlas textureNamed:@"Explode_white4@2x"];
    self.explosion5 = [self.explosionTextureAtlas textureNamed:@"Explode_white5@2x"];
    self.explosion6 = [self.explosionTextureAtlas textureNamed:@"Explode_white6@2x"];
    self.explosion7 = [self.explosionTextureAtlas textureNamed:@"Explode_white7@2x"];
    
    self.explosionTextures = @[self.explosion0, self.explosion1, self.explosion2, self.explosion3, self.explosion4, self.explosion5, self.explosion6, self.explosion7];
    
    self.explosion = [SKTexture textureWithImageNamed:@"explode@2x"];
    
    NSLog(@"Explosion textures created");
    
     [SKTexture preloadTextures:self.explosionTextures withCompletionHandler:^{
         
         NSLog(@"Explosion textures loaded");
     
         self.explosion = [SKTexture textureWithImageNamed:@"explode"];
         self.firstExplosionTexture = @[self.explosion];
     
         [SKTexture preloadTextures:self.firstExplosionTexture withCompletionHandler:^{
             
            NSLog(@"First explosion texture loaded");
             
         }];
     
     [self preloadExplosionAction];
         
     }];*/
}

- (void)preloadExplosionAction
{
    SKAction *hitSound = [SKAction playSoundFileNamed:self.hitSound waitForCompletion:NO];
    //SKAction *animate = [SKAction animateWithTextures:self.explosionTextures timePerFrame:.25/[self.explosionTextures count]];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
    SKAction *removeNode = [SKAction removeFromParent];
    
    //self.explosionAction = [SKAction sequence:@[hitSound, animate, fadeAway, removeNode]];
    self.explosionAction = [SKAction sequence:@[hitSound, fadeAway, removeNode]];
    
    //NSLog(@"Explosion action loaded");
}

- (void)preLoadMissTexture
{
    self.x = [SKTexture textureWithImageNamed:@"miss"];
    self.missTexture = @[self.x];
    
    //NSLog(@"Miss texture created");
    
    [SKTexture preloadTextures:self.missTexture withCompletionHandler:^{
        
        //NSLog(@"Miss textures loaded");
        
        [self preloadMissAction];
    }];
    
}

- (void)preloadMissAction
{
    SKAction *missSound = [SKAction playSoundFileNamed:self.missSound waitForCompletion:NO];
    SKAction *zoom = [SKAction scaleTo:1.0 duration:0.25];
    SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
    SKAction *removeNode = [SKAction removeFromParent];
    
    self.missAction = [SKAction sequence:@[missSound, zoom, fadeAway, removeNode]];
    
    //NSLog(@"Miss action loaded");
}

@end

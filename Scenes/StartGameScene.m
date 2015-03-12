//
//  StartGameScene.m
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "StartGameScene.h"

@implementation StartGameScene

//@synthesize sprite1, sprite2, sprite3, sprite4, sprite5, sprite6, sprite7, sprite8, spriteImageNames;

- (id)initWithSize:(CGSize)size {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self = [super initWithSize:size]) {
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self preloadFonts];
    //});
          
    _imageType = [self.userData valueForKey:@"imageType"];
    _backgroundFileName = [self.userData objectForKey:@"backgroundFileName"];
    _theme = [self.userData valueForKey:@"theme"];
    self.stage = [[self.userData valueForKey:@"stage"] integerValue];
    
    //NSLog(@"ImageType is : %@",self.imageType);
    //NSLog(@"Background is : %@",self.backgroundFileName);
    //NSLog(@"Theme is : %@",self.theme);
    //NSLog(@"Stage is : %lu",(unsigned long)self.stage);
    
    [self createBackgroundWithImageName:self.backgroundFileName forScreenType:self.imageType];
    [self loadStage:self.stage];
    [self createGameLogo];
    [self createPlayLabel];
    [self loadTheme:self.theme];
    [self createGameSprites];
}

- (void)createBackgroundWithImageName:(NSString *)imageName forScreenType:(NSString *)screenType {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Get correct image for the screen resolution
    NSString *backgroundImage = [Game getBackgroundImage:imageName forScreenType:screenType];
    
    // Create sprite
    self.background = [SKSpriteNode spriteNodeWithImageNamed:[backgroundImage stringByAppendingString:@".png"]];
    self.background.name = @"background";
    
    // Set sprite position
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.background.zPosition = 0;
    
    // Add sprite to scene
    //[self addChild:self.background];
    
    @try {
        [self addChild:self.background];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception adding node :%@",[exception description]);
    }
    @finally {
        
    }
}

- (void)createGameLogo {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if ([Game fileExistsInBundle:GAMELOGO ofType:@"png"]) {
        
        self.gameLogo = [SKSpriteNode spriteNodeWithImageNamed:GAMELOGO];
        
        self.gameLogo.xScale = 0.5;
        self.gameLogo.yScale = 0.5;
        self.gameLogo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 50);
        self.gameLogo.zPosition = 1;
        
        self.gameLogo.name = @"gameLogo";
        
        //[self addChild:self.gameLogo];
        
        @try {
            [self addChild:self.gameLogo];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception adding node :%@",[exception description]);
        }
        @finally {
            
        }

    }
}

- (void) createPlayLabel {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    self.playLabel = [SKSpriteNode spriteNodeWithImageNamed:@"play@2x.png"];
    
    self.playLabel.xScale = .75;
    self.playLabel.yScale = .75;
    self.playLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.15);
    self.playLabel.zPosition = 2;
    
    self.playLabel.name = @"playLabel";
    
    //[self addChild:self.playLabel];
    
    @try {
        [self addChild:self.playLabel];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception adding node :%@",[exception description]);
    }
    @finally {
        
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation
{
    self.touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //NSLog(@"Touched Node name: %@", self.touchedNode.name);
    
    [self changeScene];
}

- (void)changeScene {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    SKView *spriteView = (SKView *) self.view;
    SKScene *scene = [[GameScene alloc] initWithSize:self.size];
    
    scene.userData = [NSMutableDictionary dictionary];
    
    [scene.userData setValue:self.backgroundFileName forKey:@"backgroundFileName"];
    [scene.userData setValue:self.imageType forKey:@"imageType"];
    [scene.userData setValue:self.theme forKey:@"theme"];
    [scene.userData setValue:self.missSound forKey:@"missSound"];
    [scene.userData setValue:self.hitSound forKey:@"hitSound"];
    [scene.userData setValue:self.scoringSprite forKey:@"scoringSprite"];
    //[scene.userData setObject:self.sprites forKey:@"sprites"];
    [scene.userData setObject:self.spriteImageNames forKey:@"spriteImageNames"];
    
    NSString *stageNumberString = [NSString stringWithFormat:@"%d", self.stage];
    [scene.userData setValue:stageNumberString forKey:@"stage"];
    
    NSString *spriteSizeString  = [NSString stringWithFormat:@"%f", self.spriteSize];
    [scene.userData setValue:spriteSizeString forKey:@"spriteSize"];
    
    NSString *speedString  = [NSString stringWithFormat:@"%f", self.speed];
    [scene.userData setValue:speedString forKey:@"speed"];
    
    NSString *spinString = [NSString stringWithFormat:@"%d", self.spin];
    [scene.userData setValue:spinString forKey:@"spin"];
    
    NSString *totalGameSpritesString = [NSString stringWithFormat:@"%d", self.totalGameSprites];
    [scene.userData setValue:totalGameSpritesString forKey:@"totalGameSprites"];
    
    //NSString *winsRequiredString = [NSString stringWithFormat:@"%d", self.winsRequired];
    //[scene.userData setValue:winsRequiredString forKey:@"winsRequired"];
    
    [self removeAllActions];
    [self.background removeFromParent];
    
    [self enumerateChildNodesWithName:@"//*" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"sprite" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    SKTransition *fade = [SKTransition fadeWithDuration:.50];
    [spriteView presentScene:scene transition:fade];
}

- (void)loadTheme:(NSString *)theme {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSError *error;
    
    // File path to theme json in bundle
    
    NSString *themeFilePath = [[NSBundle mainBundle] pathForResource:theme ofType:@"json"];
    
    // Load theme json
    
    NSData *themeData = [NSData dataWithContentsOfFile:themeFilePath];
    
    // Extract json structure from theme json
    
    id JSONResponse = [NSJSONSerialization JSONObjectWithData: themeData options: NSJSONReadingMutableContainers error: &error];
    
    if ([JSONResponse isKindOfClass:[NSDictionary class]]) {
        
        if ([[JSONResponse valueForKey:@"missSound"] isKindOfClass:[NSString class]]) {
            
            self.missSound = [JSONResponse valueForKey:@"missSound"];
            if ((self.missSound.length == 0) || self.missSound == nil || (![Game fileExistsInBundle:self.missSound ofType:nil])) self.missSound = DEFAULT_SOUND_MISS;
            
        } else {
            
            self.missSound = DEFAULT_SOUND_MISS;
        }
        
        if ([[JSONResponse valueForKey:@"hitSound"] isKindOfClass:[NSString class]]) {
            
            self.hitSound = [JSONResponse valueForKey:@"hitSound"];
            if ((self.hitSound.length == 0) || self.hitSound == nil || (![Game fileExistsInBundle:self.hitSound ofType:nil])) self.hitSound = DEFAULT_SOUND_HIT;
            
        } else {
            
            self.hitSound = DEFAULT_SOUND_HIT;
        }
        
        if ([[JSONResponse valueForKey:@"stages"] isKindOfClass:[NSArray class]]) {
            
            self.stages = [JSONResponse valueForKey:@"stages"];
            
            if ((self.stages.count != 0) && self.stages != nil) {
            
                if (self.stage > [self.stages count]) self.stage = [self.stages count];
               
                NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
                
                for (mutableDictionary in self.stages) {
                
                    // Get the stage number
                    NSUInteger stageNumber = [[mutableDictionary objectForKey:@"stageNumber"] integerValue];
                
                    // Is this the stage we are looking for?
                    if (stageNumber == self.stage) {
                    
                        // Get the background and sprite image options
                        self.backgroundImages = [mutableDictionary objectForKey:@"backgroundImages"];
                        
                        if ((self.backgroundImages.count == 0) || self.backgroundImages == nil) self.backgroundFileName = DEFAULT_BACKGROUND;
                        
                        else self.backgroundFileName = self.backgroundImages[arc4random_uniform([self.backgroundImages count])];
                        
                        self.sprites = [NSMutableArray array];
                        self.spriteImageNames = [NSMutableArray array];
                
                        self.spriteImageNames = [mutableDictionary objectForKey:@"spriteImages"];
                        NSString *imageName;
                
                        for (imageName in self.spriteImageNames) {
                    
                            // Create the sprite
                    
                            SKSpriteNode *sprite;
                    
                            NSString *spriteImagename;
                            if ([self.imageType isEqualToString:@"@2x"] || [self.imageType isEqualToString:@"-568h@2x"]) {
                                spriteImagename = [imageName stringByAppendingString:@"@2x"];
                            } else {
                                spriteImagename = imageName;
                            }
                    
                            if ([Game fileExistsInBundle:spriteImagename ofType:@"png"]) sprite = [SKSpriteNode spriteNodeWithImageNamed:spriteImagename];
                            else sprite = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                            
                            sprite.name = @"sprite";
                    
                            // Create the sprite name, sprite name is the imageName plus index number on end, sprite1, sprite2
                    
                            NSUInteger indexNumber = [self.spriteImageNames indexOfObject:imageName];
                            NSString *spriteName = [@"sprite" stringByAppendingString:[NSString stringWithFormat:@"%lu", (indexNumber + 1)]];
                    
                            // Save the sprite to the correct sprite name...sprite1, sprite2
                    
                            if ([spriteName isEqualToString:@"sprite1"]) self.sprite1 = sprite;
                            else if ([spriteName isEqualToString:@"sprite2"]) self.sprite2 = sprite;
                            else if ([spriteName isEqualToString:@"sprite3"]) self.sprite3 = sprite;
                            else if ([spriteName isEqualToString:@"sprite4"]) self.sprite4 = sprite;
                            else if ([spriteName isEqualToString:@"sprite5"]) self.sprite5 = sprite;
                            else if ([spriteName isEqualToString:@"sprite6"]) self.sprite6 = sprite;
                            else if ([spriteName isEqualToString:@"sprite7"]) self.sprite7 = sprite;
                            else if ([spriteName isEqualToString:@"sprite8"]) self.sprite8 = sprite;
                            
                            if ([spriteName isEqualToString:@"sprite1"]) [self.sprites addObject:self.sprite1];
                            else if ([spriteName isEqualToString:@"sprite2"]) [self.sprites addObject:self.sprite2];
                            else if ([spriteName isEqualToString:@"sprite3"]) [self.sprites addObject:self.sprite3];
                            else if ([spriteName isEqualToString:@"sprite4"]) [self.sprites addObject:self.sprite4];
                            else if ([spriteName isEqualToString:@"sprite5"]) [self.sprites addObject:self.sprite5];
                            else if ([spriteName isEqualToString:@"sprite6"]) [self.sprites addObject:self.sprite6];
                            else if ([spriteName isEqualToString:@"sprite7"]) [self.sprites addObject:self.sprite7];
                            else if ([spriteName isEqualToString:@"sprite8"]) [self.sprites addObject:self.sprite8];
                    
                        } // for (imageName in self.spriteImageNames) {
                
                        break;
                
                    } // if (stageNumber == self.stage) {
            
                } // for (mutableDictionary in self.stages) {
                
            } else { // if ((self.stages.count == 0) || self.stages == nil) {
                
                self.backgroundFileName = DEFAULT_BACKGROUND;
                self.sprite1 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite2 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite3 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite4 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite5 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite6 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite7 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                self.sprite8 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
                
                NSLog(@"ERROR - self.stages.count == 0 or nil in theme json");
                
            } // if ((self.stages.count == 0) || self.stages == nil) {
            
        } else { // if ([[JSONResponse valueForKey:@"stages"] isKindOfClass:[NSArray class]]) {
            
            self.backgroundFileName = DEFAULT_BACKGROUND;
            self.sprite1 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite2 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite3 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite4 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite5 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite6 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite7 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            self.sprite8 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
            
            NSLog(@"ERROR - JSONResponse valueForKey:@stages in theme json is not an array");

        } // if ([[JSONResponse valueForKey:@"stages"] isKindOfClass:[NSArray class]]) {
        
    } else { // if ([JSONResponse isKindOfClass:[NSDictionary class]]) {
        
        self.backgroundFileName = DEFAULT_BACKGROUND;
        self.sprite1 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite2 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite3 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite4 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite5 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite6 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite7 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        self.sprite8 = [SKSpriteNode spriteNodeWithImageNamed:DEFAULT_SPRITE];
        
        NSLog(@"ERROR - JSONResponse in theme json is not an dictionary");
    }
}

- (void)loadStage:(NSUInteger)stage {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSError *error;
    
    // File path to theme json in bundle
    
    NSString *stageFilePath;
    
    if ([Game fileExistsInBundle:@"Stages" ofType:@"json"]) {
        stageFilePath = [[NSBundle mainBundle] pathForResource:@"Stages" ofType:@"json"];
    } else {
        NSLog(@"ERROR - Can't find file Stages.json");
        return;
    }
    
    // Load theme json
    
    NSData *stageData = [NSData dataWithContentsOfFile:stageFilePath];
    
    // Extract json structure from theme json
    
    id JSONResponse = [NSJSONSerialization JSONObjectWithData: stageData options: NSJSONReadingMutableContainers error: &error];
    
    if ([JSONResponse isKindOfClass:[NSDictionary class]]) {
        
        NSArray *stagesArray = [JSONResponse objectForKey:@"stages"];
        NSUInteger theStageNumber;
        
        for (NSDictionary *dictionary in stagesArray) {
            
            if ([[dictionary valueForKey:@"stageNumber"] isKindOfClass:[NSString class]]) {
                
                theStageNumber = [[dictionary valueForKey:@"stageNumber"] integerValue];
                
                if (theStageNumber == stage) {
                    
                // Size
                    if ([[dictionary valueForKey:@"size"] isKindOfClass:[NSString class]]) {
                        self.spriteSize = [[dictionary valueForKey:@"size"] floatValue];
                        if (self.spriteSize < .25) self.spriteSize = DEFAULT_SIZE;
                    } else {
                        NSLog(@"ERROR - [dictionary valueForKey:@size] NOT isKindOfClass:[NSString class]");
                        self.spriteSize = DEFAULT_SIZE;
                    }
                // Speed
                    if ([[dictionary valueForKey:@"speed"] isKindOfClass:[NSString class]]) {
                        self.speed = [[dictionary valueForKey:@"speed"] floatValue];
                        if (self.speed < .50 || self.speed >= 2.0) self.speed = DEFAULT_SPEED;
                    } else {
                        NSLog(@"ERROR - [dictionary valueForKey:@speed] NOT isKindOfClass:[NSString class]");
                        self.speed = DEFAULT_SPEED;
                    }
                // Spin
                    if ([[dictionary valueForKey:@"spin"] isKindOfClass:[NSString class]]) {
                        self.spin = [[dictionary valueForKey:@"spin"] integerValue];
                        if (self.spin != 1 || self.spin != 0) self.spin = DEFAULT_SPIN;
                    } else {
                        NSLog(@"ERROR - [dictionary valueForKey:@spin] NOT isKindOfClass:[NSString class]");
                        self.spin = DEFAULT_SPIN;
                    }
                // Total sprites
                    if ([[dictionary valueForKey:@"totalGameSprites"] isKindOfClass:[NSString class]]) {
                        self.totalGameSprites = [[dictionary valueForKey:@"totalGameSprites"] integerValue];
                        if (self.totalGameSprites < 50) self.totalGameSprites = DEFAULT_TOTALSPRITES;
                    } else {
                        NSLog(@"ERROR - [dictionary valueForKey:@totalGameSprites] NOT isKindOfClass:[NSString class]");
                        self.totalGameSprites = DEFAULT_TOTALSPRITES;
                    }
                // Wins required
                    /*if ([[dictionary valueForKey:@"winsRequired"] isKindOfClass:[NSString class]]) {
                        self.winsRequired = [[dictionary valueForKey:@"winsRequired"] integerValue];
                        if (self.winsRequired < 50) self.winsRequired = DEFAULT_WINSREQUIRED;
                    } else {
                        NSLog(@"ERROR - [dictionary valueForKey:@winsRequired] NOT isKindOfClass:[NSString class]");
                        self.winsRequired = DEFAULT_WINSREQUIRED;
                    }*/
                    
                    break;
                    
                } // if (theStageNumber == self.stage) {
                
            } else { // if ([[dictionary valueForKey:@"stageNumber"] isKindOfClass:[NSString class]]) {
                
                self.spriteSize = DEFAULT_SIZE;
                self.spin = DEFAULT_SPEED;
                self.speed = DEFAULT_SPIN;
                self.totalGameSprites = DEFAULT_TOTALSPRITES;
                //self.winsRequired = DEFAULT_WINSREQUIRED;
                
                NSLog(@"ERROR - [dictionary valueForKey:@stageNumber] NOT isKindOfClass:[NSString class]");
            }
            
        } // for (NSDictionary *dictionary in stagesArray) {
        
    } else { // if ([JSONResponse isKindOfClass:[NSDictionary class]]) {
        
        self.spriteSize = DEFAULT_SIZE;
        self.spin = DEFAULT_SPEED;
        self.speed = DEFAULT_SPIN;
        self.totalGameSprites = DEFAULT_TOTALSPRITES;
        //self.winsRequired = DEFAULT_WINSREQUIRED;
        
        NSLog(@"ERROR - [JSONResponse NOT isKindOfClass:[NSDictionary class]");
    }
}

- (void)createGameSprites {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    float topOffset = 125;
    float rowHeight = 80;
    float columnOffset = 60;
    
    float row1_y = CGRectGetMaxY(self.frame) - topOffset;
    float row2_y = CGRectGetMaxY(self.frame) - topOffset - rowHeight;
    float row3_y = CGRectGetMaxY(self.frame) - topOffset - (rowHeight * 2);
    float row4_y = CGRectGetMaxY(self.frame) - topOffset - (rowHeight * 3);
    
    CGPoint row1Column1 = CGPointMake(CGRectGetMidX(self.frame) - columnOffset, row1_y);
    CGPoint row1Column2 = CGPointMake(CGRectGetMidX(self.frame) + columnOffset, row1_y);
    CGPoint row2Column1 = CGPointMake(CGRectGetMidX(self.frame) - columnOffset, row2_y);
    CGPoint row2Column2 = CGPointMake(CGRectGetMidX(self.frame) + columnOffset, row2_y);
    CGPoint row3Column1 = CGPointMake(CGRectGetMidX(self.frame) - columnOffset, row3_y);
    CGPoint row3Column2 = CGPointMake(CGRectGetMidX(self.frame) + columnOffset, row3_y);
    CGPoint row4Column1 = CGPointMake(CGRectGetMidX(self.frame) - columnOffset, row4_y);
    CGPoint row4Column2 = CGPointMake(CGRectGetMidX(self.frame) + columnOffset, row4_y);
    
    if (self.sprite1) self.sprite1.position = row1Column1;
    if (self.sprite2) self.sprite2.position = row1Column2;
    if (self.sprite3) self.sprite3.position = row2Column1;
    if (self.sprite4) self.sprite4.position = row2Column2;
    if (self.sprite5) self.sprite5.position = row3Column1;
    if (self.sprite6) self.sprite6.position = row3Column2;
    if (self.sprite7) self.sprite7.position = row4Column1;
    if (self.sprite8) self.sprite8.position = row4Column2;
    
    float xScale = .50;
    
    if (self.sprite1) self.sprite1.xScale = xScale;
    if (self.sprite2) self.sprite2.xScale = xScale;
    if (self.sprite3) self.sprite3.xScale = xScale;
    if (self.sprite4) self.sprite4.xScale = xScale;
    if (self.sprite5) self.sprite5.xScale = xScale;
    if (self.sprite6) self.sprite6.xScale = xScale;
    if (self.sprite7) self.sprite7.xScale = xScale;
    if (self.sprite8) self.sprite8.xScale = xScale;
    
    float yScale = .50;
    
    if (self.sprite1) self.sprite1.yScale = yScale;
    if (self.sprite2) self.sprite2.yScale = yScale;
    if (self.sprite3) self.sprite3.yScale = yScale;
    if (self.sprite4) self.sprite4.yScale = yScale;
    if (self.sprite5) self.sprite5.yScale = yScale;
    if (self.sprite6) self.sprite6.yScale = yScale;
    if (self.sprite7) self.sprite7.yScale = yScale;
    if (self.sprite8) self.sprite8.yScale = yScale;

    if (self.sprite1) self.sprite1.position = row1Column1;
    if (self.sprite2) self.sprite2.position = row1Column2;
    if (self.sprite3) self.sprite3.position = row2Column1;
    if (self.sprite4) self.sprite4.position = row2Column2;
    if (self.sprite5) self.sprite5.position = row3Column1;
    if (self.sprite6) self.sprite6.position = row3Column2;
    if (self.sprite7) self.sprite7.position = row4Column1;
    if (self.sprite8) self.sprite8.position = row4Column2;
    
    if (self.sprite1) [self addChild:self.sprite1];
    if (self.sprite2) [self addChild:self.sprite2];
    if (self.sprite3) [self addChild:self.sprite3];
    if (self.sprite4) [self addChild:self.sprite4];
    if (self.sprite5) [self addChild:self.sprite5];
    if (self.sprite6) [self addChild:self.sprite6];
    if (self.sprite7) [self addChild:self.sprite7];
    if (self.sprite8) [self addChild:self.sprite8];
    
    NSString *randomSprite = self.spriteImageNames[arc4random_uniform([self.spriteImageNames count])];
    self.scoringSprite = randomSprite;
    
    NSUInteger scoringSpriteIndex = [self.spriteImageNames indexOfObject:self.scoringSprite];
    
    SKAction *fadeOut = [SKAction fadeOutWithDuration: 0.5];
    SKAction *fadeIn = [SKAction fadeInWithDuration: 0.5];
    SKAction *wait = [SKAction waitForDuration: 1.0];
    SKAction *pulse = [SKAction sequence:@[fadeOut,fadeIn, wait]];
    
    SKAction *pulseForever = [SKAction repeatActionForever:pulse];
    
    if (scoringSpriteIndex == 0 && self.sprite1) [self.sprite1 runAction:pulseForever];
    if (scoringSpriteIndex == 1 && self.sprite2) [self.sprite2 runAction:pulseForever];
    if (scoringSpriteIndex == 2 && self.sprite3) [self.sprite3 runAction:pulseForever];
    if (scoringSpriteIndex == 3 && self.sprite4) [self.sprite4 runAction:pulseForever];
    if (scoringSpriteIndex == 4 && self.sprite5) [self.sprite5 runAction:pulseForever];
    if (scoringSpriteIndex == 5 && self.sprite6) [self.sprite6 runAction:pulseForever];
    if (scoringSpriteIndex == 6 && self.sprite7) [self.sprite7 runAction:pulseForever];
    if (scoringSpriteIndex == 7 && self.sprite8) [self.sprite8 runAction:pulseForever];
}

- (void)preloadFonts {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    //NSLog(@"StartGameScene preloadFonts - Start");
    
    SKLabelNode *preload = [SKLabelNode labelNodeWithFontNamed:SKLABEL_GAME_FONT];
    preload.text = @"text";
    
    //NSLog(@"StartGameScene preloadFonts - End");
}

@end

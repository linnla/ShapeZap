//
//  EndGameScene.m
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "EndGameScene.h"

@implementation EndGameScene

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
    self.stage = [[self.userData valueForKey:@"stage"] integerValue];
    //self.winsRequired = [[self.userData valueForKey:@"winsRequired"] integerValue];
    
    self.hits = [[self.userData valueForKey:@"hits"] integerValue];
    self.misses = [[self.userData valueForKey:@"misses"] integerValue];
    self.elapsedTime = [[self.userData valueForKey:@"elapsedTime"] floatValue];
    
    //NSLog(@"Hits are : %lu",(unsigned long)self.hits);
    //NSLog(@"Misses are : %lu",(unsigned long)self.misses);
    //NSLog(@"elasped time is : %lu",(unsigned long)self.elapsedTime);
    
    [self createBackgroundWithImageName:DEFAULT_BACKGROUND forScreenType:self.imageType];
    
    [self determineOutcome];
    [self getMessageForOutcome:self.gameOutcome];
    [self createSceneContents];
}

- (void)createSceneContents
{
    // Game Over Message Line 1
    
    SKLabelNode *gameOverMessageLabel1;
    gameOverMessageLabel1 = [[SKLabelNode alloc] initWithFontNamed:SKLABEL_GAME_FONT];
    
    gameOverMessageLabel1.name = @"message1";
    gameOverMessageLabel1.text = self.gameOverMessage1;
    gameOverMessageLabel1.scale = 1.0;
    gameOverMessageLabel1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.8);
    gameOverMessageLabel1.fontColor = SKLABEL_FONTCOLOR_WHITE;
    gameOverMessageLabel1.fontSize = SKLABEL_FONTSIZE_ENDGAME;
    
    [self addChild:gameOverMessageLabel1];
    
    // Game Over Message Line 2
    
    SKLabelNode *gameOverMessageLabel2;
    gameOverMessageLabel2 = [[SKLabelNode alloc] initWithFontNamed:SKLABEL_GAME_FONT];
    
    gameOverMessageLabel2.name = @"message2";
    gameOverMessageLabel2.text = self.gameOverMessage2;
    gameOverMessageLabel2.scale = 1.0;
    gameOverMessageLabel2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.7);
    gameOverMessageLabel2.fontColor = SKLABEL_FONTCOLOR_WHITE;
    gameOverMessageLabel2.fontSize = SKLABEL_FONTSIZE_ENDGAME;
    
    [self addChild:gameOverMessageLabel2];
    
    // Continue / Try Again Button
    
    if (self.win) self.playAgainButton = [[SKSpriteNode alloc] initWithImageNamed:@"continue@2x"];
    else self.playAgainButton = [[SKSpriteNode alloc] initWithImageNamed:@"try_again@2x"];
    
    self.playAgainButton.xScale = .50;
    self.playAgainButton.yScale = .50;
    self.playAgainButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.5);
    self.playAgainButton.name = @"playAgain";
    
    [self addChild:self.playAgainButton];
        
    // Change Theme Button
    
    self.changeThemeButton  = [SKSpriteNode spriteNodeWithImageNamed:@"change_theme@2x"];
    
    self.changeThemeButton.xScale = .50;
    self.changeThemeButton.yScale = .50;
    self.changeThemeButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.3);
    self.changeThemeButton.name = @"changeTheme";
    
    [self addChild:self.changeThemeButton];
}

- (void)determineOutcome
{
    if (self.hits >= SCORE_HITS_REQUIRED) {
        
        self.win = YES;
        self.gameOutcome = @"SCORE_HITS_REQUIRED";
        self.playAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"continue@2x"];
        
    } else if (self.elapsedTime >= GAMETIME) {
        
        self.win = NO;
        self.gameOutcome = @"GAMETIME";
        self.playAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"try_again@2x"];
        
    } else if (self.misses >= SCORE_MISSES_ALLOWED) {
        
        self.win = NO;
        self.gameOutcome = @"SCORE_MISSES_ALLOWED";
        self.playAgainButton = [SKSpriteNode spriteNodeWithImageNamed:@"try_again@2x"];
    }
}

- (void)getMessageForOutcome:(NSString *)gameOutcome
{
    // Message on Line 1
    NSMutableArray *line1Message = [NSMutableArray array];
    
    // Message on line 2
    NSMutableArray *line2Message = [NSMutableArray array];
    
    if (self.win) {
        
        [line1Message addObject:@"Congratulations!"];
        [line1Message addObject:@"You're amazing!"];
        [line1Message addObject:@"You did it!"];
        [line1Message addObject:@"You're a super star!"];
        [line1Message addObject:@"Success!"];
        [line1Message addObject:@"Wow!"];
        
        [line2Message addObject:@"You won."];
        [line2Message addObject:@"You've moving on."];
        [line2Message addObject:@"You're on the path."];
     
    } else {
        
        [line1Message addObject:@"Better luck next time."];
        [line1Message addObject:@"Oh no!"];
        [line1Message addObject:@"Can't win them all."];
        
        if (self.elapsedTime >= GAMETIME) {
             
            [line2Message addObject:@"You ran out of time."];
            [line2Message addObject:@"Time is up."];
            [line2Message addObject:@"Speed it up."];
            [line2Message addObject:@"Improve your speed."];
             
        } else {
             
            [line2Message addObject:@"Too many misses."];
            [line2Message addObject:@"You missed too many."];
            [line2Message addObject:@"You're X'd out."];
            [line2Message addObject:@"Improve your accuracy."];
             
        }
    }

    // Get random messages from the message arrays
    if ([line1Message count] > 0) self.gameOverMessage1 = line1Message[arc4random_uniform([line1Message count])];
    if ([line2Message count] > 0) self.gameOverMessage2 = line2Message[arc4random_uniform([line2Message count])];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation
{
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //NSLog(@"Touched Node Name: %@", touchedNode.name);
    
    if ([touchedNode.name isEqualToString:@"background"]) return;
    else if ([touchedNode.name isEqualToString:@"changeTheme"]) self.nextScene = @"changeTheme";
    else if ([touchedNode.name isEqualToString:@"playAgain"]) self.nextScene = @"playAgain";
    
    [self changeScene];
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

- (void)changeScene
{
    [self removeAllActions];
    
    [self enumerateChildNodesWithName:@"changeTheme" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"playAgain" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"message1" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    [self enumerateChildNodesWithName:@"message2" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];

    SKView *spriteView = (SKView *) self.view;
    SKScene *scene;
    
    if ([self.nextScene isEqualToString:@"playAgain"]) scene = [[StartGameScene alloc] initWithSize:self.size];
    else scene = [[ThemeScene alloc] initWithSize:self.size];
    
    scene.userData = [NSMutableDictionary dictionary];
    
    [scene.userData setValue:DEFAULT_BACKGROUND forKey:@"backgroundFileName"];
    [scene.userData setValue:self.imageType forKey:@"imageType"];
    [scene.userData setValue:self.theme forKey:@"theme"];
    
    if (self.win) self.stage +=1;
    NSString *stageNumberString = [NSString stringWithFormat:@"%d", self.stage];
    [scene.userData setValue:stageNumberString forKey:@"stage"];
    
    //NSString *winsRequiredString = [NSString stringWithFormat:@"%d", self.winsRequired];
    //[scene.userData setValue:winsRequiredString forKey:@"winsRequired"];
    
    NSString *hitsString = [NSString stringWithFormat:@"%d", self.hits];
    [scene.userData setValue:hitsString forKey:@"hits"];
    
    NSString *missesString = [NSString stringWithFormat:@"%d", self.misses];
    [scene.userData setValue:missesString forKey:@"misses"];
    
    NSString *elaspedTimeString = [NSString stringWithFormat:@"%f", self.elapsedTime];
    [scene.userData setValue:elaspedTimeString forKey:@"elaspedTime"];
    
    SKTransition *fade = [SKTransition fadeWithDuration:.50];
    [spriteView presentScene:scene transition:fade];
}

@end

//
//  MyScene.m
//  ShapeZap
//
//  Created by Laure Linn on 3/31/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self createBackground];
    }
    return self;
}

- (void)createBackground
{
    // Get the imageType (@2x, -586h@2x)
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.imageType = [defaults stringForKey:@"imageType"];
    
    // Get image
    
    NSString *backgroundImageName = @"bg_purple";
    backgroundImageName = [[backgroundImageName stringByAppendingString:self.imageType] stringByAppendingString:@".png"];
    
    // Create sprite
    SKTexture *texture = [SKTexture textureWithImageNamed:backgroundImageName];
    self.background = [SKSpriteNode spriteNodeWithTexture:texture];
    self.background.name = @"background";
    
    // Set position
    
    self.background.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
    self.background.zPosition = 0;

    // Add background to scene
                             
    [self addChild:self.background];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    [self createHighResRandomGameSprite];
    //[self createLowResRandomGameSprite];
}

- (void) createHighResRandomGameSprite
{
    // Create the texture
    
    NSString *spriteImage = @"annulus_orange@2x.png";
    SKTexture *texture = [SKTexture textureWithImageNamed:spriteImage];
    
    // Create the sprite
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    
    // Size the sprite
    
    sprite.yScale = .33;
    sprite.xScale = .33;
        
    // Position the sprite
    
    sprite.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
    sprite.zPosition = 1;
    
    // Add physics to sprite
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 2];
    sprite.physicsBody.affectedByGravity = YES;
    sprite.physicsBody.dynamic = YES;
    
    // Add sprite to scene
    
    [self addChild:sprite];
}

- (void) createLowResRandomGameSprite
{
    // Create the texture
    
    NSString *spriteImage = @"annulus_orange.png";
    SKTexture *texture = [SKTexture textureWithImageNamed:spriteImage];
    
    // Create the sprite
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    
    // Size the sprite
    
    sprite.yScale = .66;
    sprite.xScale = .66;
    
    // Position the sprite
    
    sprite.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    sprite.zPosition = 1;
    
    // Add physics to sprite
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 2];
    sprite.physicsBody.affectedByGravity = YES;
    sprite.physicsBody.dynamic = YES;
    
    // Add sprite to scene
    
    [self addChild:sprite];
}

@end

//
//  ThemeScene.m
//  ShapeZap
//
//  Created by Laure Linn on 4/1/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "ThemeScene.h"

@implementation ThemeScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view
{
    self.imageType = [self.userData valueForKey:@"imageType"];
    self.backgroundFileName = [self.userData objectForKey:@"backgroundFileName"];
    
    self.themes = [self getThemes];
    
    if (self.themes.count != 0) {
        
        [self createBackgroundWithImageName:self.backgroundFileName forScreenType:self.imageType];
        [self createGameLogo];
        [self createThemeIcons];
    }
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

- (void)createGameLogo
{
    if ([Game fileExistsInBundle:GAMELOGO ofType:@"png"]) {
        
        self.gameLogo = [SKSpriteNode spriteNodeWithImageNamed:GAMELOGO];
        
        self.gameLogo.xScale = 0.5;
        self.gameLogo.yScale = 0.5;
        self.gameLogo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 50);
        self.gameLogo.zPosition = 1;
        
        self.gameLogo.name = @"gameLogo";
        
        [self addChild:self.gameLogo];
    }
}

- (void)createThemeIcons
{
    // Images are scaled down (xScale, yScale) so take that into account
    float imageWidth = 200 * .5;
    float imageHeight = 200 * .5;
    float topOffset = 105;
    
    float screenWidth = self.frame.size.width;
    float horzontialOffset = (screenWidth - (imageWidth * 3)) / 4;
    float verticalOffset = 20;
    
    NSUInteger columnNumber = 1;
    NSUInteger rowNumber = 1;
    
    float x;
    float y;
    
    for (NSString *theme in self.themes) {
        
        NSString *imageName = [theme stringByAppendingString:@"@2x.png"];
        NSString *themeName = theme;
        
        SKSpriteNode *themeNode = [[SKSpriteNode alloc] initWithImageNamed:imageName];
        
        themeNode.xScale = .5;
        themeNode.yScale = .5;
        
        themeNode.name = themeName;
        themeNode.anchorPoint = CGPointMake(0.0, 1.0);
        
        // Set Y position
        
        if (rowNumber == 1) y = CGRectGetMaxY(self.frame) - topOffset;
        else y = CGRectGetMaxY(self.frame) - topOffset - ((rowNumber - 1) * (verticalOffset + imageHeight));
        
        // Set X position & column / row number
        
        if (columnNumber == 1) {
            x = horzontialOffset;
            columnNumber = 2;
        } else if (columnNumber == 2) {
            x = horzontialOffset + imageWidth + horzontialOffset;
            columnNumber = 3;
        } else {
            x = horzontialOffset + imageWidth + horzontialOffset + imageWidth + horzontialOffset;
            columnNumber = 1;
            rowNumber = rowNumber + 1;
        }
        
        themeNode.position = CGPointMake(x, y);
        themeNode.zPosition = 3;
        
        [self addChild:themeNode];
    }
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation
{
    self.touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    
    //NSLog(@"Touched Node name: %@", self.touchedNode.name);
    
    if ([self.touchedNode.name isEqualToString:@"background"] || [self.touchedNode.name isEqualToString:@"gameLogo"] || [self.touchedNode.name isEqualToString:@"gameDirections"]) {
        return;
    }
    
    if (self.touchedNode.name) {
        
        self.theme = self.touchedNode.name;
        [self changeScene];
    }
}

- (void)changeScene
{
    SKView *spriteView = (SKView *) self.view;
    SKScene *scene = [[StartGameScene alloc] initWithSize:self.size];
    
    scene.userData = [NSMutableDictionary dictionary];
    
    [scene.userData setValue:self.backgroundFileName forKey:@"backgroundFileName"];
    [scene.userData setValue:self.imageType forKey:@"imageType"];
    [scene.userData setValue:self.theme forKey:@"theme"];
    [scene.userData setValue:@"1" forKey:@"stage"];
    
    SKTransition *fade = [SKTransition fadeWithDuration:.50];
    [spriteView presentScene:scene transition:fade];
}

- (NSArray *)getThemes
{
    NSArray *themeFilesFound = [self getFileNamesFromBundleMatchingExtension:@".json" withPrefix:@"Theme_"];
    
    NSError *error;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (!themeFilesFound || [themeFilesFound count] == 0) {
        
        NSLog(@"ERROR - No Themes Found");
        
    } else {
        
        for (NSString *themeFileName in themeFilesFound) {
            
            NSArray *fileNameComponents = [themeFileName componentsSeparatedByString: @"."];
            NSString *file = [fileNameComponents objectAtIndex: 0];
            
            NSString *themeFilePath = [[NSBundle mainBundle] pathForResource:file ofType:@"json"];
            
            NSData *themeData = [NSData dataWithContentsOfFile:themeFilePath];
            
            id JSONResponse = [NSJSONSerialization JSONObjectWithData: themeData options: NSJSONReadingMutableContainers error: &error];
            
            if ([JSONResponse isKindOfClass:[NSDictionary class]]) {
                
                NSString *themeName = [JSONResponse valueForKey:@"themeName"];
                [array addObject:themeName];
                
            } else {
                
                NSLog(@"ERROR - No Themes Found");
        
            }
        }
    }
    
    return array;
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

- (NSArray *) getFileNamesFromBundleMatchingExtension:(NSString *)extension withPrefix:(NSString *)prefix
{
    // Initialize arrays
    
    NSMutableArray *filesMatchingExtension = [[NSMutableArray alloc] init];
    NSMutableArray *filesMatchingExtensionAndPrefix = [[NSMutableArray alloc] init];
    
    // Get list of files from main application bundle that match the file extension
    
    filesMatchingExtension = [[[NSBundle mainBundle] pathsForResourcesOfType:extension inDirectory:nil] mutableCopy];
    
    if ([filesMatchingExtension count] > 0) {
        
        int numberOfCharacatersInPrefix = 0;
        
        if (prefix) {
            numberOfCharacatersInPrefix = (int)prefix.length;
        }
        
        for(NSString *file in filesMatchingExtension) {
            
            NSString *fileName = [file lastPathComponent];
            
            if (prefix) {
                
                // If the prefix is not = nil or fileName conatins the prefix
                
                NSString *substringToCompareToThePrefix = [[fileName substringFromIndex:0] substringToIndex:numberOfCharacatersInPrefix];
                
                if (numberOfCharacatersInPrefix == 0 || [substringToCompareToThePrefix isEqualToString:prefix]) {
                    
                    //Add fileName to the array
                    
                    [filesMatchingExtensionAndPrefix addObject:fileName];
                    
                }
            }
        }
    }
    
    //NSLog(@"Files matching extension in bundle = %d", (int)[filesMatchingExtension count]);
    //NSLog(@"Files matching extension and prefix in bundle = %d", (int)[filesMatchingExtensionAndPrefix count]);
    
    return filesMatchingExtensionAndPrefix;
    
}

@end

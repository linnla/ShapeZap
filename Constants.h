//
//  Constants.h
//  ShapeZap
//
//  Created by Laure Linn on 2/17/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

// FONTS

//#define SKLABEL_CONFIGURATION_FONT @"AvenirNext-Medium"
#define SKLABEL_GAME_FONT @"Chalkboard SE"

//#define SKLABEL_FONTCOLOR_ORANGE [SKColor orangeColor]
#define SKLABEL_FONTCOLOR_WHITE [SKColor whiteColor]

#define SKLABEL_FONTSIZE_ENDGAME 20
//#define SKLABEL_FONTSIZE_GAMELOGO 32
#define SKLABEL_FONTSIZE_SCORE 20
#define SKLABEL_FONTSIZE_SCORELABEL 18
//#define SKLABEL_FONTSIZE_CONFIGURATION 16

// GAME DEFAULTS

#define GAMELOGO @"shape_zap_logo@2x"
#define EXPLOSIONIMAGE @"explosion1@2x"
#define MISSIMAGE @"X@2x"
#define DEFAULT_SOUND_HIT @"FXhome.com Futuristic Gun Sound 09.mp3"
#define DEFAULT_SOUND_MISS @"beep-08.wav"
#define DEFAULT_SPEED 1.0
#define DEFAULT_SIZE .90
#define DEFAULT_TOTALSPRITES 100
#define DEFAULT_GAMESPRITES 6
#define DEFAULT_SPIN 0
//#define DEFAULT_WINSREQUIRED 1
#define DEFAULT_GRAVITY_DX 0
#define DEFAULT_GRAVITY_DY -1.0
#define DEFAULT_ENTRY_POINT -70.0;
#define DEFAULT_DYNAMIC YES
#define DEFAULT_ALLOWSROTATION YES
#define DEFAULT_AFFECTEDBYGRAVITY YES
#define DEFAULT_FRICTION 0
#define DEFAULT_LINEARDAMPING 0
#define DEFAULT_RESTITUTION 1.0
#define DEFAULT_BACKGROUND @"bg_blue"
#define DEFAULT_THEME @"Theme_Daisies"
#define DEFAULT_SPRITE @"flower_06_orange@2x"
//#define DEFAULT_SPRITE1 @"flower_06_orange@2x"
//#define DEFAULT_SPRITE2 @"flower_06_orange@2x"
//#define DEFAULT_SPRITE3 @"flower_06_orange@2x"
//#define DEFAULT_SPRITE4 @"flower_06_orange@2x"
//#define DEFAULT_SELECTED_SPRITE @"flower_06_orange@2x"

#define DEFAULT_VECTORIMPLUSE_MIN -30.0
#define DEFAULT_VECTORIMPLUSE_MAX 30.0

// BACKGROUND IMAGES

//#define BACKGROUND_COLOR BLACK_LIGHT

//#define BACKGROUND_ENDGAME @"bg_yellow_orange_01"
//#define BACKGROUND_STARTGAME @"bg_yellow_orange_01"

// GAME PARAMETERS

#define GAMETIME 18
#define SCORE_MISSES_ALLOWED 3
#define SCORE_HITS_REQUIRED 3
#define SCORE_HITS_REQUIRED_ZEROGRAVITY 3

@end


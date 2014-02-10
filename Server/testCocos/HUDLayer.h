//
//  HUDLayer.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/5/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "CCLayer.h"
#import "CCLabelBMFont.h"
#import "CC3Foundation.h"
#import "CCDirector.h"
#import "CGPointExtension.h"

@interface HUDLayer : CCLayer



// Add after @interface
- (void)setStatusString:(NSString *)string;

@end

//
//  HUDLayer.m
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/5/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "HUDLayer.h"

// Add inside @interface
CCLabelBMFont * _statusLabel;

@implementation HUDLayer

- (id)init {
    
    if ((self = [super init])) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"arial16.fnt"];
        } else {
            _statusLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"arial16.fnt"];
        }
        _statusLabel.position = ccp(winSize.width* 0.85, winSize.height * 0.9);
        [self addChild:_statusLabel];
    }
    return self;
}

- (void)setStatusString:(NSString *)string {
    _statusLabel.string = string;
}

@end

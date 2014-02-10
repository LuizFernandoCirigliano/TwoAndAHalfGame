//
//  SimpleAudioPlayer.h
//  AmazeGameController
//
//  Created by Francesco Perrotti-Garcia on 2/6/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleAudioPlayer : NSObject

+ (SimpleAudioPlayer *) sharedPlayer;
- (void)playSoundWithFileName :(NSString *)fileName andExtension:(NSString *) extension;

@end

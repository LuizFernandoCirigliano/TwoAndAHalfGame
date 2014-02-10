//
//  SimpleAudioPlayer.m
//  AmazeGameController
//
//  Created by Francesco Perrotti-Garcia on 2/6/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "SimpleAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SimpleAudioPlayer () <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation SimpleAudioPlayer

static SimpleAudioPlayer *mySimpleAudioPlayer = nil;

+ (SimpleAudioPlayer *) sharedPlayer
{
    
    if (!mySimpleAudioPlayer)
    {
        mySimpleAudioPlayer = [[super allocWithZone:nil] init];
    }
    
    return mySimpleAudioPlayer;
}

- (void) playSoundWithFileName:(NSString *)fileName andExtension:(NSString *)extension
{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:extension];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    self.audioPlayer.volume = 0.7;
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

@end

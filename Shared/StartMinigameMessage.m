//
//  StartMinigameMessage.m
//  TwoAndAHalfGame
//
//  Created by Francesco Perrotti-Garcia on 1/30/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "StartMinigameMessage.h"

@implementation StartMinigameMessage

/**
 * Add method description here
 *
 */
- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"startMinigameMessage"];
}
@end

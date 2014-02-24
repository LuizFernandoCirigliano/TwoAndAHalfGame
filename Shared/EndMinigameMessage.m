//
//  EndMinigameMessage.m
//  Amaze Game
//
//  Created by Luiz Fernando 2 on 2/24/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "EndMinigameMessage.h"

@implementation EndMinigameMessage

- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"endMinigameMessage"];
}

@end

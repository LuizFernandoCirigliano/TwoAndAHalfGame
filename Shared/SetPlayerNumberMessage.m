//
//  SetPlayerNumberMessage.m
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "SetPlayerNumberMessage.h"

@implementation SetPlayerNumberMessage

/**
 * Add method description here
 *
 \param playerNumber Parameter Description
 */
-(id) initWithPlayerNumber: (NSInteger)playerNumber
{
    self = [super init];
    
    if(self) {
        self.playerNumber = [NSNumber numberWithInt:playerNumber];
    }
    
    return self;
}

/**
 * Add method description here
 *
 */
- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"buttonPressMessage"];
}

#pragma marks NSCoding Protocols

/**
 * Add method description here
 *
 \param decoder Parameter Description
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.playerNumber = [decoder decodeObjectForKey:@"playerNumber"];
    }
    return self;
}

/**
 * Add method description here
 *
 \param encoder Parameter Description
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.playerNumber forKey:@"playerNumber"];
}

@end

//
//  JankenResultMessage.m
//  AmazeGameController
//
//  Created by Luiz Fernando 2 on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "JankenResultMessage.h"

@implementation JankenResultMessage

-(id) initWithJankenResult: (NSInteger)result andPlayerNumber: (NSInteger)number
{
    self = [super init];
    
    if(self) {
        self.jankenResult = [NSNumber numberWithInt:result];
        self.playerNumber = [NSNumber numberWithInt:number];
    }
    
    return self;
}

/**
 * Add method description here
 *
 */
- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"jankenResultMessage"];
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
        self.jankenResult = [decoder decodeObjectForKey:@"jankenResult"];
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
    [encoder encodeObject:self.jankenResult forKey:@"jankenResult"];
    [encoder encodeObject:self.playerNumber forKey:@"playerNumber"];
}
@end

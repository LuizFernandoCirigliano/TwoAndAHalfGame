//
//  PaperBattleCallbackMessage.m
//  Amaze Game Controller
//
//  Created by Francesco Perrotti-Garcia on 2/21/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "PaperBattleCallbackMessage.h"

@implementation PaperBattleCallbackMessage

/**
 * Add method description here
 *
 \param buttonNumber Parameter Description
 \param playerNumber Parameter Description
 */
-(id) initWithButtonNumber: (NSInteger)buttonNumber andPlayer:(NSInteger)playerNumber
{
    self = [super init];
    
    if(self)
    {
        self.buttonNumber = [NSNumber numberWithInt:buttonNumber];
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
    return [self archiveDataWithKey:@"paperBattleCallbackPressMessage"];
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
        self.buttonNumber = [decoder decodeObjectForKey:@"buttonNumber"];
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
    [encoder encodeObject:self.buttonNumber forKey:@"buttonNumber"];
    [encoder encodeObject:self.playerNumber forKey:@"playerNumber"];
}

@end

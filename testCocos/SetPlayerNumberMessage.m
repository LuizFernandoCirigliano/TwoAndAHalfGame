//
//  SetPlayerNumberMessage.m
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "SetPlayerNumberMessage.h"

@implementation SetPlayerNumberMessage

-(id) initWithPlayerNumber: (NSInteger)playerNumber{
    self = [super init];
    
    if(self) {
        self.playerNumber = [NSNumber numberWithInt:playerNumber];
    }
    
    return self;
}

- (NSData *)archiveData{
    return [self archiveDataWithKey:@"buttonPressMessage"];
}

#pragma marks NSCoding Protocols

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.playerNumber = [decoder decodeObjectForKey:@"playerNumber"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.playerNumber forKey:@"playerNumber"];
}

@end

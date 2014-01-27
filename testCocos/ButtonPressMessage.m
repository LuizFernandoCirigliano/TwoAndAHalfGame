//
//  ButtonPressMessage.m
//  GameMultipeerTest
//
//  Created by Luiz Fernando 2 on 1/16/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "ButtonPressMessage.h"

@implementation ButtonPressMessage

-(id) initWithButtonNumber: (NSInteger)buttonNumber andPlayer:(NSInteger)playerNumber{
    self = [super init];
    
    if(self) {
        self.buttonNumber = [NSNumber numberWithInt:buttonNumber];
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
        self.buttonNumber = [decoder decodeObjectForKey:@"buttonNumber"];
        self.playerNumber = [decoder decodeObjectForKey:@"playerNumber"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.buttonNumber forKey:@"buttonNumber"];
    [encoder encodeObject:self.playerNumber forKey:@"playerNumber"];
}
@end

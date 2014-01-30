//
//  SetPlayerNumberMessage.h
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 1/28/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "NewMessage.h"

@interface SetPlayerNumberMessage : NewMessage

- (NSData *)archiveData;

/**
 * Add property description here
 */
@property (strong, nonatomic) NSNumber *playerNumber;


-(id) initWithPlayerNumber: (NSInteger)playerNumber;

@end

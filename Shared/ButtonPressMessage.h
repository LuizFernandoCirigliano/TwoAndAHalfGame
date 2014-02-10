//
//  ButtonPressMessage.h
//  AmazeGameController
//
//  Created by Luiz Fernando 2 on 1/16/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "NewMessage.h"

@interface ButtonPressMessage : NewMessage
- (NSData *)archiveData;

/**
 * Add property description here
 */
@property (strong, nonatomic) NSNumber *buttonNumber;

/**
 * Add property description here
 */
@property (strong, nonatomic) NSNumber *playerNumber;


-(id) initWithButtonNumber: (NSInteger)buttonNumber andPlayer: (NSInteger)playerNumber;

@end

//
//  PaperBattleButtonPressMessage.h
//  Amaze Game Controller
//
//  Created by Francesco Perrotti-Garcia on 2/21/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "NewMessage.h"

@interface PaperBattleButtonPressMessage : NewMessage

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
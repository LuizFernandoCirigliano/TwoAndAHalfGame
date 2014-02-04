//
//  JankenResultMessage.h
//  GameMultipeerTest
//
//  Created by Luiz Fernando 2 on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "NewMessage.h"

@interface JankenResultMessage : NewMessage

@property (strong, nonatomic) NSNumber *jankenResult;
@property (strong, nonatomic) NSNumber *playerNumber;

-(id) initWithJankenResult: (NSInteger)result andPlayerNumber: (NSInteger)number;
- (NSData *)archiveData;

@end

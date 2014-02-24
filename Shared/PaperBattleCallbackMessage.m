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
 */
- (NSData *)archiveData
{
    return [self archiveDataWithKey:@"paperBattleCallbackPressMessage"];
}



@end

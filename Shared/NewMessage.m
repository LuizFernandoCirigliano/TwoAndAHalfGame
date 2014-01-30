//
//  NewMessage.m
//  Fila-Cliente
//
//  Created by João Marcos Suckow de Barros Rodrigues on 12/11/13.
//  Copyright (c) 2013 Luiz Fernando Cirigliano Villela. All rights reserved.
//

#import "NewMessage.h"

@implementation NewMessage

/**
 * Add method description here
 *
 \param key Parameter Description
 */
- (NSData *)archiveDataWithKey: (NSString *) key
{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey: key];
    
    return data;
}

#pragma marks NSCoding Protocols

/**
 * Add method description here
 *
 \param key Parameter Description
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        #warning Possible incomplete method implementation.
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
    #warning Possible incomplete method implementation.
}


@end
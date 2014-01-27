//
//  NewMessage.m
//  Fila-Cliente
//
//  Created by João Marcos Suckow de Barros Rodrigues on 12/11/13.
//  Copyright (c) 2013 Luiz Fernando Cirigliano Villela. All rights reserved.
//

#import "NewMessage.h"

@implementation NewMessage

- (NSData *)archiveDataWithKey: (NSString *) key{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey: key];
    
    return data;
}

#pragma marks NSCoding Protocols

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}


@end
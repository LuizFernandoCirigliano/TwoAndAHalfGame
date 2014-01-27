
//
//  NewMessage.h
//  fila-server
//
//  Created by João Marcos Suckow de Barros Rodrigues on 07/11/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewMessage : NSObject <NSCoding>

- (NSData *)archiveDataWithKey: (NSString *) key;


@end
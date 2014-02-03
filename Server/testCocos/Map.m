//
//  Map.m
//  TwoAndAHalfGame
//
//  Created by Luiz Fernando 2 on 2/3/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "Map.h"

@implementation Map

static Map *myMapConfiguration = nil;

+ (Map *) myMap
{
    
    if (!myMapConfiguration)
    {
        myMapConfiguration = [[super allocWithZone:nil] init];
#warning Possible incomplete method implementation.
    }
    
    return myMapConfiguration;
}

/**
 * Add method description here
 *
 */
-(void) readMapFile
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"map01"
                                                     ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    int lineSize = (int) [content rangeOfString: @"\n"].location + 1; //acha tamanho da linha pelo primeiro \n
    
    self.lines = [NSMutableArray arrayWithCapacity: (NSUInteger) 2];
    
    int initialPos = 0; //initR indica a posicao inicial da proxima "linha"
    
    for(int lineNumber = 0; initialPos < content.length; lineNumber++)
    {
        initialPos = lineSize*lineNumber; //calcula comeco da proxima linha
        if (initialPos >= content.length)
            continue;
        NSMutableString *nextLine;
        if(lineSize*(lineNumber+1) >= content.length) //caso da ultima linha, pega string a partir da posicao incial
        {
            nextLine = (NSMutableString *) [content substringFromIndex:(NSUInteger) initialPos];
            
        }
        else // se nao for a ultima linha, pega a substring a partir de initialPos e "corta" apenas caracteres ate \n seguinte
        {
            nextLine = (NSMutableString *) [[content substringFromIndex:(NSUInteger) initialPos] substringToIndex:(NSUInteger) lineSize - 1];
        }
        
        nextLine = [nextLine stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self.lines addObject: nextLine]; //adiciona string a array de linhas
        
        NSLog(@"%@", nextLine);
    }
    
    self.xTileCount = [self.lines count];
    self.zTileCount = [[self.lines firstObject] length];
    
    NSLog(@"%d %d", self.xTileCount, self.zTileCount);

}


-(void) setSizesWithMapX : (float) xSize andMapZ: (float) zSize {
    self.mapSizeX = xSize;
    self.mapSizeZ = zSize;
    
    self.tileSizeX = xSize / self.xTileCount;
    self.tileSizeZ = zSize / self.zTileCount;
}

-(CGPoint) locationInMapWithPosition: (CGPoint) position {
    CGPoint point = CGPointMake(floorf((position.x + self.mapSizeX)/ (2*self.tileSizeX)), floorf((position.y + self.mapSizeZ) / (2*self.tileSizeZ)));
    
    return point;
}

-(CGPoint) positionInMapWithLocation: (CGPoint) location {
    CGPoint position = CGPointMake(-self.mapSizeX + self.tileSizeX*location.x, -self.mapSizeZ + self.tileSizeZ*location.y);
    
    return position;
}

-(char) contentOfMapAtLocation:(CGPoint)location {
    
    return [[self.lines objectAtIndex:self.xTileCount - (int)location.x - 1] characterAtIndex:self.zTileCount - (int)location.y - 1];
    
}
@end

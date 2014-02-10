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
        
        nextLine = (NSMutableString *) [nextLine stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        for (int i = 0; i < nextLine.length; i++)
        {
            char c = [nextLine characterAtIndex:i];
            switch (c)
            {
                case 'a':
                    self.playerASpawnPoint = CGPointMake(lineNumber, i);
                    break;
                case 'b':
                    self.playerBSpawnPoint = CGPointMake(lineNumber, i);
                    break;
                case 'c':
                    self.playerCSpawnPoint = CGPointMake(lineNumber, i);
                    break;
                case 'd':
                    self.playerDSpawnPoint = CGPointMake(lineNumber, i);
                    break;
                default:
                    break;
            }
        }
        
        [self.lines addObject: nextLine]; //adiciona string a array de linhas
        
//        NSLog(@"%@", nextLine);
    }
    
    self.xTileCount = [self.lines count];
    self.zTileCount = [[self.lines firstObject] length];
    
//    NSLog(@"%d %d", self.xTileCount, self.zTileCount);

}

/**
 * Sets the map and tile size for the map
 \param xSize size in the x axis
 \param zSize size in the z axis
 */
-(void) setSizesWithMapX : (float) xSize andMapZ: (float) zSize
{
    self.mapSizeX = xSize;
    self.mapSizeZ = zSize;
    
    self.tileSizeX = xSize / self.xTileCount;
    self.tileSizeZ = zSize / self.zTileCount;
}

//This method receives a position (float values for x and z) and returns the indexes for the corresponding tile
-(CGPoint) locationInMapWithPosition: (CGPoint) position
{
    CGPoint location = CGPointMake(floorf((position.x + self.mapSizeX/2)/ self.tileSizeX), floorf((position.y + self.mapSizeZ/2) / self.tileSizeZ));
    
    return location;
}

//This method receives the tile indexes and returns the center position (float values) for the center of the tile
-(CGPoint) positionInMapWithLocation: (CGPoint) location
{
    CGPoint position = CGPointMake(-self.mapSizeX/2 + self.tileSizeX*location.x , -self.mapSizeZ/2 + self.tileSizeZ*location.y );
    
    return position;
}

//returns the character at the location tile
-(char) contentOfMapAtLocation:(CGPoint)location
{
    return [[self.lines objectAtIndex:self.xTileCount - (int)location.x - 1] characterAtIndex:self.zTileCount - (int)location.y - 1];
}

-(void) replaceAtLocation:(CGPoint) location withChar: (char) c{
    NSLog(@"%c", [self contentOfMapAtLocation:location]);
    [[self.lines objectAtIndex:self.xTileCount - (int)location.x - 1] replaceCharactersInRange:NSMakeRange(self.zTileCount - (int)location.y - 1, 1) withString:[NSString stringWithFormat:@"%c",c]];
    NSLog(@"%c", [self contentOfMapAtLocation:location]);
}
@end

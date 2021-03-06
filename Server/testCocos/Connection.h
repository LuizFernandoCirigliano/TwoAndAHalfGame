//
//  Connection.h
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "NewMessage.h"
#import "StartGameMessage.h"
#import "EndRoundMessage.h"
#import "ButtonPressMessage.h"
#import "SetPlayerNumberMessage.h"
#import "StartMinigameMessage.h"
#import "JankenResultMessage.h"
#import "PaperBattleButtonPressMessage.h"
#import "PaperBattleCallbackMessage.h"

#define MAX_PLAYERS 4

//w Protocol should be documented.
@protocol ConnectionDelegate <NSObject>

@required

- (void) changeConnectionToState: (MCSessionState)state forPlayerNumber: (NSInteger)playerNumber;

@end

//w Protocol should be documented.
@protocol GameConnectionDelegate <NSObject>

@required
-(void) otherPlayerPressed:(ButtonPressMessage *) buttonPressMessage ;
@end


@interface Connection : NSObject <MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate>

/**
 * Add property description here
 */
@property (nonatomic, strong) MCBrowserViewController *browserVC;

/**
 * Add property description here
 */
@property (nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;

/**
 * Add property description here
 */
@property (nonatomic, strong) MCSession *mySession;

/**
 * Add property description here
 */
@property (nonatomic, strong) MCPeerID *myPeerID;

/**
 * Add property description here
 */
@property (nonatomic, assign) id delegate;

/**
 * Add property description here
 */
@property (nonatomic, strong) NSMutableArray *peerArray;

+ (Connection *) myConnection;
+ (Connection *) myConnectionWithName: (NSString *) peerName;

- (void) showBrowserVC:(UIViewController*)controller;
- (void) sendData: (NSData *)data;
- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer;
@end

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


@protocol ConnectionDelegate <NSObject>

@required
- (void)startGame;
- (void)ready;
@end

@protocol GameDelegate <NSObject>

@required
-(void) roundEnded;
-(void) otherPlayerPressed:(NSNumber *) buttonNumber ;
-(void) startMinigame;
@end


@interface Connection : NSObject <MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCBrowserViewController *browserVC;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *mySession;
@property (nonatomic, strong) MCPeerID *myPeerID;


@property (nonatomic, assign) id delegate;
@property int playerNumber;

@property (nonatomic, strong) MCPeerID *serverPeerID;

+ (Connection *) myConnection;
+ (Connection *) myConnectionWithName: (NSString *) peerName;

- (void) showBrowserVC:(UIViewController*)controller;
- (void) sendData: (NSData *)data;
- (void) sendDataToServer: (NSData *)data;
- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer;

@end

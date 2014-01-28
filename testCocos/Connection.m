//
//  Connection.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "Connection.h"
#import "NewMessage.h"
#import "StartGameMessage.h"
#import "EndRoundMessage.h"
#import "ButtonPressMessage.h"

@implementation Connection

static Connection *myConnectionConfiguration = nil;

+ (Connection *) myConnectionWithName: (NSString *) peerName{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName: peerName];
    }
    
    return myConnectionConfiguration;
}

+ (Connection *) myConnection{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName:@"simulador"];
    }
    
    return myConnectionConfiguration;
}

-(Connection *) initWithName : (NSString *) peerName{
    
    self = [super init];
    
    if(self){
        //  Setup peer ID
        self.myPeerID = [[MCPeerID alloc] initWithDisplayName:peerName];
        
        //  Setup session
        self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
        
        //  Setup BrowserViewController
        self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"controllertest" session:self.mySession];
        
        //  Setup Advertiser
        self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.myPeerID discoveryInfo:nil serviceType:@"controllertest"];
        [self.advertiser startAdvertisingPeer];
        
        self.advertiser.delegate = self;
        self.browserVC.delegate = self;
        self.mySession.delegate = self;
        
        
        self.peerArray = [NSMutableArray array];
    }
    
    return self;
}
- (void) sendData:(NSData *) data {
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
        NSLog(@"%@", [error description]);
    }
}

- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer{
    NSError *error;
    [self.mySession sendData:data toPeers:[NSArray arrayWithObject:peer] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
//        NSLog(@"%@", [error description]);
    }
}

- (void) showBrowserVC:(UIViewController*)controller{
    [controller presentViewController:self.browserVC animated:YES completion:nil];
}

- (void) dismissBrowserVC{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate
// Remote peer changed state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    if (state ==  MCSessionStateConnected) {
        //checks if it's a reconnection
        for (int i = 0; i < [self.peerArray count]; i++) {
            if ([self.peerArray objectAtIndex:i] == peerID)
                return;
        }
        
        

        NSData *data = [[[SetPlayerNumberMessage alloc] initWithPlayerNumber:[self.peerArray count]] archiveData];
        
        [self.peerArray addObject:peerID];
        NSLog(@"Player Number: %d", [self.peerArray count]);
        
        
        [self sendData:data toPeer: peerID];
    }
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NewMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (message == nil) {
        NSLog(@"erro, mensagem nula");
    } else if ([message isKindOfClass:[StartGameMessage class]]) {
        if ([self.delegate respondsToSelector:@selector(startGame)])
        {
            [self.advertiser stopAdvertisingPeer];
            [self.delegate performSelector:@selector(startGame)];
        }
    } else if ([message isKindOfClass:[EndRoundMessage class]]) {
        if ([self.delegate respondsToSelector:@selector(roundEnded)])
        {
            [self.delegate performSelector:@selector(roundEnded)];
        }
    } else if ([message isKindOfClass:[ButtonPressMessage class]]) {
        if ([self.delegate respondsToSelector:@selector(otherPlayerPressed: )])
        {
            ButtonPressMessage *buttonMessage = (ButtonPressMessage *) message;
            [self.delegate performSelector:@selector(otherPlayerPressed: ) withObject:buttonMessage];
        }
    }
}

// Received a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

#pragma marks MCNearbyServiceAdvertiserDelegate

//Accept automatically
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler {
    
    invitationHandler(YES, self.mySession);
    
}

@end

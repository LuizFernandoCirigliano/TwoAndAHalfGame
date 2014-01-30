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

#warning Add pragma marks to this file.

@implementation Connection

/**
 * Add description here
 */
static Connection *myConnectionConfiguration = nil;

/**
 * Add method description here
 *
 \param peerName Parameter Description
 */
+ (Connection *) myConnectionWithName: (NSString *) peerName
{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName: peerName];
    }
    
    return myConnectionConfiguration;
}

/**
 * Add method description here
 *
 \param peerName Parameter Description
 */
+ (Connection *) myConnection
{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName:@"simulador"];
#warning Possible incomplete method implementation.
    }
    
    return myConnectionConfiguration;
}

/**
 * Add method description here
 *
 \param peerName Parameter Description
 */
-(Connection *) initWithName : (NSString *) peerName
{
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

/**
 * Add method description here
 *
 \param data Parameter Description
 */
- (void) sendData:(NSData *) data
{
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
        NSLog(@"%@", [error description]);
    }
}

/**
 * Add method description here
 *
 \param data Parameter Description
 \param peer Parameter Description
 */
- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer{
    NSError *error;
    [self.mySession sendData:data toPeers:[NSArray arrayWithObject:peer] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
//        NSLog(@"%@", [error description]);
    }
}

/**
 * Add method description here
 *
 \param controller Parameter Description
 */
- (void) showBrowserVC:(UIViewController*) controller
{
    [controller presentViewController:self.browserVC animated:YES completion:nil];
}

/**
 * Add method description here
 *
 */
- (void) dismissBrowserVC
{
    [self.browserVC dismissViewControllerAnimated:YES completion:nil];
}

/**
 * Add method description here
 *
 \param browserViewController Parameter Description
 */
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserVC];
}

/**
 * Add method description here
 *
 \param browserViewController Parameter Description
 */
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    [self dismissBrowserVC];
}

#pragma marks MCSessionDelegate

// Remote peer changed state
/**
 * Add method description here
 *
 \param peerID Parameter Description
 \param state Parameter Description
 */
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state ==  MCSessionStateConnected)
    {
        //checks if it's a reconnection
        for (int i = 0; i < [self.peerArray count]; i++)
        {
            if ([self.peerArray objectAtIndex:i] == peerID)
            {
                return;
            }
        }
        
        

        NSData *data = [[[SetPlayerNumberMessage alloc] initWithPlayerNumber:[self.peerArray count]] archiveData];
        
        [self.peerArray addObject:peerID];
        NSLog(@"Player Number: %d", [self.peerArray count]);
        
        
        [self sendData:data toPeer: peerID];
    }
}

// Received data from remote peer
/**
 * Add method description here
 *
 \param sessionParameter Description
 \param data Parameter Description
 \param peerID Parameter Description
 */
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

/**
 * Add method description here
 *
 \param session Parameter Description
 \param stream Parameter Description
 \param streamName Parameter Description
 \param peerID Parameter Description
 */
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    // Received a byte stream from remote peer
    #warning Possible incomplete method implementation.
}


/**
 * Add method description here
 *
 \param session Parameter Description
 \param resourceName Parameter Description
 \param peerID Parameter Description
 \param progress Parameter Description
 */
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    // Start receiving a resource from remote peer
    #warning Possible incomplete method implementation.
}

/**
 * Add method description here
 *
 \param session Parameter Description
 \param resourceName Parameter Description
 \param peerID Parameter Description
 \param localURL Parameter Description
 \param error Parameter Description
 */
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    #warning Possible incomplete method implementation.
}

#pragma marks MCNearbyServiceAdvertiserDelegate

//Accept automatically
/**
 * Add method description here
 *
 \param advertiser Parameter Description
 \param peerID Parameter Description
 \param context Parameter Description
 \param invitationHandler Parameter Description
 */
- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    
    invitationHandler(YES, self.mySession);
    
}

@end
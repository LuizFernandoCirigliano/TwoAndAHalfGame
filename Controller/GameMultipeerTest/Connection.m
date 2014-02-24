//
//  Connection.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "Connection.h"
#import "ControllerViewController.h"
@implementation Connection

/* This classes sets up the remote connection between devices, and handles interactions using the message transfer system

    Always set the correct delegate (depending what the current state is) to the current view controller
*/
static Connection *myConnectionConfiguration = nil;

//Methods for the Singleton pattern of this class.

//Setup the connection with a custom display name (passed by peerName)
+ (Connection *) myConnectionWithName: (NSString *) peerName{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName: peerName];
    }
    
    return myConnectionConfiguration;
}

//Setup the connection with standard display name using device name
+ (Connection *) myConnection{
    
    if (!myConnectionConfiguration)
    {
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName:[UIDevice currentDevice].identifierForVendor.UUIDString];
    }
    
    return myConnectionConfiguration;
}

-(Connection *) initWithName : (NSString *) peerName{
    
    self = [super init];
    
    if(self){
        //  Setup peer ID
        self.peerName = peerName;
        [self configureConnection];
    }
    
    return self;
}

-(void) configureConnection {
    self.myPeerID = [[MCPeerID alloc] initWithDisplayName:self.peerName];
    
    //  Setup session
    self.mySession = [[MCSession alloc] initWithPeer:self.myPeerID];
    
    //  Setup BrowserViewController
    self.browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"controllertest" session:self.mySession];
    
    self.browserVC.delegate = self;
    self.mySession.delegate = self;
}
#pragma mark - Connection event handling

//this is used to send messages to all the connected devices for the current session
//data must be an archived message class.
- (void) sendData:(NSData *) data {
    NSError *error;
    [self.mySession sendData:data toPeers:[self.mySession connectedPeers] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
        NSLog(@"%@", [error description]);
    }
}

//same as above, except this one sends to a single peer instead of all connected devices
- (void) sendData:(NSData *) data toPeer:(MCPeerID *) peer{
    NSError *error;
    [self.mySession sendData:data toPeers:[NSArray arrayWithObject:peer] withMode:MCSessionSendDataUnreliable error: &error];
    if(error) {
//        NSLog(@"%@", [error description]);
    }
}

-(void) sendDataToServer: (NSData *) data {
    [self.mySession sendData:data toPeers:[NSArray arrayWithObject:self.serverPeerID] withMode:MCSessionSendDataUnreliable error:nil];
}

// Received data from remote peer
// session - The active connection session
// data - Encapsulates one of the message classes. Use the archive/unarchive methods to obtain the message with the properties
// peerID - the ID from the device that sent the data on the current session. Can be used to send some sort of response message

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NewMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (message == nil)
    {
        NSLog(@"erro, mensagem nula");
    }
    else if ([message isKindOfClass:[SetPlayerNumberMessage class]])
    {
        SetPlayerNumberMessage *playerNumberMessage = (SetPlayerNumberMessage *)message;
        NSLog(@"%d", [[playerNumberMessage playerNumber] intValue]);
        self.playerNumber = [[playerNumberMessage playerNumber] intValue];
        self.serverPeerID = peerID;
        
    }
    else if ([message isKindOfClass:[StartMinigameMessage class]])
    {
        if([self.delegate respondsToSelector:@selector(startMinigame)])
        {
            NSLog(@"MESSAGE RECEIVED");
            [self.delegate performSelectorOnMainThread:@selector(startMinigame) withObject:nil waitUntilDone:NO];
        }
        
    }
    else if ([message isKindOfClass:[EndRoundMessage class]])
    {
        if ([self.delegate respondsToSelector:@selector(endGame)])
        {
            [self.delegate performSelectorOnMainThread:@selector(endGame) withObject:nil waitUntilDone:NO];
        }
    }
    
    else if ([message isKindOfClass:[PaperBattleCallbackMessage class]]) {
        if ([self.delegate respondsToSelector:@selector(startPaperBattle)]) {
            [self.delegate performSelectorOnMainThread:@selector(startPaperBattle) withObject:nil waitUntilDone:NO];
        }
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
    if (state == MCSessionStateNotConnected && peerID == self.serverPeerID && [self.delegate isKindOfClass:[ControllerViewController class]]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate dismissViewControllerAnimated:YES completion:nil];
        });

    }
}

// Received; a byte stream from remote peer
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
}

// Start receiving a resource from remote peer
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
}

// Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
}

@end

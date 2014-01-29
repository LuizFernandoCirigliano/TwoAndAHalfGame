//
//  Connection.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "Connection.h"

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
        myConnectionConfiguration = [[super allocWithZone:nil] initWithName:[UIDevice currentDevice].name];
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
        self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"controllertest" discoveryInfo:nil session:self.mySession];
        [self.advertiser start];
        
        self.browserVC.delegate = self;
        self.mySession.delegate = self;
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
    
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    NewMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (message == nil) {
        NSLog(@"erro, mensagem nula");
    } else if ([message isKindOfClass:[SetPlayerNumberMessage class]]) {
        SetPlayerNumberMessage *playerNumberMessage = (SetPlayerNumberMessage *)message;
        NSLog(@"%d", [[playerNumberMessage playerNumber] intValue]);
        self.playerNumber = [[playerNumberMessage playerNumber] intValue];
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

@end

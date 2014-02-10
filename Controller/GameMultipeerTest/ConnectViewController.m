//
//  ConnectViewController.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "ConnectViewController.h"
#import "Connection.h"
#import "StartGameMessage.h"


@interface ConnectViewController()

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ConnectViewController

- (void) viewDidLoad
{
    [Connection myConnection];
    [Connection myConnection].delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollview.contentSize = self.view.bounds.size;
}

- (void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    [Connection myConnection].delegate = self;
    
    if ([Connection myConnection].mySession.connectedPeers.count > 0)
    {
        [self startGameAction];
    } else {
        [[Connection myConnection] configureConnection];
    }
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.scrollview.contentSize = self.view.bounds.size;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}


- (IBAction)showBrowserVC:(id)sender
{
    [[Connection myConnection] showBrowserVC:self];
}

- (void) startGameAction
{
    NSData *data = [[[StartGameMessage alloc] init] archiveData];
    [[Connection myConnection] sendData:data];
    [self startGame];
}

-(void) startGame {
    [self performSegueWithIdentifier:@"startGameSegue" sender:nil];
}

-(void) ready {
    
}

@end

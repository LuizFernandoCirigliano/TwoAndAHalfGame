//
//  ConnectViewController.m
//  GestureShenanigans
//
//  Created by Luiz Fernando 2 on 11/22/13.
//  Copyright (c) 2013 Luiz Fernando 2. All rights reserved.
//

#import "ConnectViewController.h"

#import "StartGameMessage.h"


@interface ConnectViewController()

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ConnectViewController

-(void)viewDidLoad{
    [Connection myConnection];
    [Connection myConnection].delegate = self;
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.scrollview.contentSize = self.view.bounds.size;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.scrollview.contentSize = self.view.bounds.size;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}


- (IBAction)showBrowserVC:(id)sender {
    [[Connection myConnection] showBrowserVC:self];
}
- (IBAction)startGameAction:(id)sender {
    NSData *data = [[[StartGameMessage alloc] init] archiveData];
    [[Connection myConnection] sendData:data];
    [self startGame];
}

-(void) startGame {
    [self performSegueWithIdentifier:@"startGameSegue" sender:self];
}

-(void) ready {
    
}

@end

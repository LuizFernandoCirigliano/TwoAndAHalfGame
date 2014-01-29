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

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;

@end

@implementation ConnectViewController


- (IBAction)setUpConnection:(UIButton *)sender {
    if ([self.name.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro" message:@"Falta nome" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
    } else {
        [Connection myConnectionWithName:self.name.text];
        sender.hidden = YES;
        self.connectButton.hidden = NO;
        [Connection myConnection].delegate = self;
    }
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

//
//  JankenViewController.m
//  GameMultipeerTest
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "JankenViewController.h"
#import "Connection.h"

@interface JankenViewController ()

@end

@implementation JankenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)click:(UIButton *)sender
{
    NSData *data = [[[JankenResultMessage alloc] initWithJankenResult:sender.tag andPlayerNumber:[[Connection myConnection] playerNumber]] archiveData];
    
    //currently sending to all peers, limit to send only to server
    [[Connection myConnection] sendDataToServer:data];
}

@end

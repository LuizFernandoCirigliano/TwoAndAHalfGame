//
//  PaperBattleViewController.m
//  Amaze Game Controller
//
//  Created by Francesco Perrotti-Garcia on 2/21/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "PaperBattleViewController.h"
#import "PaperBattleButtonPressMessage.h"
#import "Connection.h"

@interface PaperBattleViewController ()

@end

@implementation PaperBattleViewController

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

- (IBAction)buttonClicked:(UIButton *)sender
{
    NSData *data = [[[PaperBattleButtonPressMessage alloc] initWithButtonNumber:sender.tag andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    [[Connection myConnection] sendData:data];
}




@end

//
//  JankenViewController.m
//  GameMultipeerTest
//
//  Created by Francesco Perrotti-Garcia on 2/4/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "JankenViewController.h"
#import "Connection.h"

#define kJankenTLE 3

@interface JankenViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pickLabel;

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
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(timeLimitExceeded)
                                   userInfo:nil
                                    repeats:NO];
    self.view.userInteractionEnabled = YES;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)click:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 0:
            self.pickLabel.text = @"rock";
            break;
        case 1:
            self.pickLabel.text = @"paper";
            break;
        case 2:
            self.pickLabel.text = @"scissors";
            break;
        default:
            break;
    }
    [self send:sender.tag];
}

- (void) timeLimitExceeded
{
    [self send:kJankenTLE];
}

- (void) send: (NSInteger) gestureID
{
    NSData *data = [[[JankenResultMessage alloc] initWithJankenResult:gestureID andPlayerNumber:[[Connection myConnection] playerNumber]] archiveData];
    
    //currently sending to all peers, limit to send only to server
    [[Connection myConnection] sendDataToServer:data];
    self.view.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

@end

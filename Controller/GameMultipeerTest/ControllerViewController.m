//
//  ControllerViewController.m
//  GameMultipeerTest
//
//  Created by Luiz Fernando 2 on 1/16/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "ControllerViewController.h"
#import "ButtonPressMessage.h"
@interface ControllerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@end

@implementation ControllerViewController

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
    [Connection myConnection].delegate = self;
    self.playerLabel.text = [NSString stringWithFormat:@"Player %d", [[Connection myConnection] playerNumber]+1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buttonPress:(UIButton *)sender {
    NSData *data = [[[ButtonPressMessage alloc] initWithButtonNumber:sender.tag andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    [[Connection myConnection] sendData:data];
}

- (IBAction)buttonRelease:(UIButton *)sender {
    NSData *data = [[[ButtonPressMessage alloc] initWithButtonNumber:4 andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    [[Connection myConnection] sendData:data];
}


-(void) otherPlayerPressed:(NSNumber *) buttonNumber {
    NSLog(@"%ld", (long)[buttonNumber integerValue]);
}
-(void) roundEnded {
    NSLog(@"test");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"fim de jogo" message:@"fim de jogo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

@end

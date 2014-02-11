//
//  ControllerViewController.m
//  AmazeGameController
//
//  Created by Luiz Fernando 2 on 1/16/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "ControllerViewController.h"
#import "ButtonPressMessage.h"
#import "JSDPad.h"
#import "JSButton.h"
#import "SimpleAudioPlayer.h"

@interface ControllerViewController ()  <JSDPadDelegate>
@property (weak, nonatomic) IBOutlet JSButton *button0;
@property (weak, nonatomic) IBOutlet JSButton *button1;
@property (weak, nonatomic) IBOutlet JSButton *button2;
@property (weak, nonatomic) IBOutlet JSButton *button3;
@property (weak, nonatomic) IBOutlet UIImageView *playerImage;


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
    
    [self.playerImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"p%d.png", [[Connection myConnection] playerNumber]+1]]];
    
    [[self.button0 titleLabel] setText:@"0"];
	[self.button0 setBackgroundImage:[UIImage imageNamed:@"button"]];
	[self.button0 setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    
    [[self.button1 titleLabel] setText:@"1"];
	[self.button1 setBackgroundImage:[UIImage imageNamed:@"button"]];
	[self.button1 setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    
    [[self.button2 titleLabel] setText:@"2"];
	[self.button2 setBackgroundImage:[UIImage imageNamed:@"button"]];
	[self.button2 setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    
    [[self.button3 titleLabel] setText:@"3"];
	[self.button3 setBackgroundImage:[UIImage imageNamed:@"button"]];
	[self.button3 setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) roundEnded {
    NSLog(@"test");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"fim de jogo" message:@"fim de jogo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

#pragma mark - JSDPadDelegate

- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
    //Player should stop walking
    NSData *data = [[[ButtonPressMessage alloc] initWithButtonNumber:4 andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    [[Connection myConnection] sendData:data];
    
    NSInteger tag;
    [[SimpleAudioPlayer sharedPlayer] playSoundWithFileName:@"button" andExtension:@"wav"];

    switch (direction)
    {
        case JSDPadDirectionUp:
            tag = 0;
            break;
        case JSDPadDirectionRight:
            tag = 1;
            break;
        case JSDPadDirectionDown:
            tag = 2;
            break;
        case JSDPadDirectionLeft:
            tag = 3;
            break;
        case JSDPadDirectionUpRight:
            tag = 10;
            break;
        case JSDPadDirectionDownRight:
            tag = 20;
            break;
        case JSDPadDirectionDownLeft:
            tag = 30;
            break;
        case JSDPadDirectionUpLeft:
            tag = 40;
            break;
        default:
            tag = -1;
            break;
    }
    data = [[[ButtonPressMessage alloc] initWithButtonNumber:tag andPlayer:[[Connection myConnection] playerNumber]] archiveData];

    [[Connection myConnection] sendDataToServer:data];
}

- (void)dPadDidReleaseDirection:(JSDPad *)dPad
{
	NSData *data = [[[ButtonPressMessage alloc] initWithButtonNumber:4 andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    [[Connection myConnection] sendData:data];
}

- (void) startMinigame
{
    [self performSegueWithIdentifier:@"startMinigame" sender:nil];
}

-(void) endGame
{
#warning possible issue with controller reconnections
    [[Connection myConnection].mySession disconnect];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

//w Add credits do JSController
@end

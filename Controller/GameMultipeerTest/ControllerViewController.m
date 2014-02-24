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
#import "CircularTimerView.h"

@interface ControllerViewController ()  <JSDPadDelegate, JSButtonDelegate>
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
    
    NSArray *buttons = @[self.button0, self.button1, self.button2, self.button3];
    NSArray *buttonColors = @[[UIColor blueColor], [UIColor redColor], [UIColor whiteColor], [UIColor greenColor]];
    NSArray *buttonTimeIntervals = @[@60.0f, @30.0f, @45.0f, @15.0f];
    
    for (int i = 0; i < buttons.count; i++)
    {
        JSButton *button = buttons[i];
        UIColor *color = buttonColors[i];
        
        [button setBackgroundImage:[UIImage imageNamed:@"button"]];
        [button setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
        
        button.radius = button.frame.size.height /2;
        button.size = button.radius * 0.2f;
        button.timeInterval = [buttonTimeIntervals[i] doubleValue];
        button.annulusColor = color;
        
        CircularTimerView *always = [[CircularTimerView alloc] initWithPosition:CGPointMake(-button.size, -button.size) radius:button.radius+button.size internalRadius:button.radius];
        
        always.backgroundColor = color;
        always.foregroundColor = color;
        always.direction = CircularTimerViewDirectionClockwise;
        [always setupCountdown:NSTimeIntervalSince1970];
        [button addSubview:always];

        }
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

#pragma mark - JSButtonDelegate

- (void) buttonPressed:(JSButton *)button
{
    NSData *data = [[[ButtonPressMessage alloc] initWithButtonNumber:button.tag andPlayer:[[Connection myConnection] playerNumber]] archiveData];
    
    [[Connection myConnection] sendDataToServer:data];
    
    CircularTimerView *timerView;
    timerView = [[CircularTimerView alloc] initWithPosition:CGPointMake(-button.size, -button.size) radius:button.radius+button.size internalRadius:button.radius];
    
    //Set background
    timerView.backgroundColor = [UIColor lightGrayColor];
    timerView.backgroundFadeColor = button.annulusColor;
    
    //Set fade
    timerView.foregroundColor = [UIColor blackColor];
    timerView.foregroundFadeColor = button.annulusColor;
    timerView.direction = CircularTimerViewDirectionClockwise;
    
    
    [timerView setupCountdown:button.timeInterval];
    
    timerView.startBlock = ^(CircularTimerView *timerView)
    {
        button.userInteractionEnabled = NO;
    };
    
    timerView.endBlock = ^(CircularTimerView *timerView)
    {
        button.userInteractionEnabled = YES;
    };
    
    [button addSubview:timerView];

}

- (void) startMinigame
{
    [self performSegueWithIdentifier:@"startMinigame" sender:nil];
}

- (void) startPaperBattle
{
    [self performSegueWithIdentifier:@"startPaperBattleMinigame" sender:nil];
}

-(void) endGame
{
    [[Connection myConnection].mySession disconnect];
}

//w Add credits do JSController e CircularTimerView
@end

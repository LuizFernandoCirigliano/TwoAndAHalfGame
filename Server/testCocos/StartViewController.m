//
//  StartViewController.m
//  Amaze Game
//
//  Created by Luiz Fernando 2 on 2/14/14.
//  Copyright (c) 2014 Luiz Fernando 2. All rights reserved.
//

#import "StartViewController.h"
#import "Connection.h"

@interface StartViewController () <ConnectionDelegate>

@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *connectionStatusLabels;

@end

@implementation StartViewController

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
    
    //Order the outlet array based on their X position.
    self.connectionStatusLabels = [self.connectionStatusLabels sortedArrayUsingComparator:^NSComparisonResult(id label1, id label2) {
        if ([label1 frame].origin.x < [label2 frame].origin.x) return NSOrderedAscending;
        else if ([label1 frame].origin.x > [label2 frame].origin.x) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    
    
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [Connection myConnection].delegate = self;
    
    for (UILabel *label in self.connectionStatusLabels) {
        label.text = @"Not Connected!";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_connectionStatusLabels release];
    [super dealloc];
}

- (void) changeConnectionToState:(MCSessionState)state forPlayerNumber:(NSInteger)playerNumber {
    UILabel *label= [self.connectionStatusLabels objectAtIndex:playerNumber];
    switch (state) {
        case MCSessionStateConnected:
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:@"Connected"];
                label.textColor = [UIColor greenColor];
            });
            break;
        case MCSessionStateNotConnected:
            
            dispatch_async(dispatch_get_main_queue(), ^{
                label.textColor = [UIColor redColor];
                [label setText:@"Disconnected"];
                
            });
            break;
        case MCSessionStateConnecting:
            dispatch_async(dispatch_get_main_queue(), ^{
                [label setText:@"connecting"];
                label.textColor = [UIColor yellowColor];
                
            });
        default:
            break;
    }
}
@end

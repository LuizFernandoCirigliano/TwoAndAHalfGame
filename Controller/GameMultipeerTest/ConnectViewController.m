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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@end

@implementation ConnectViewController

-(void)viewDidLoad{
    // add gesture recognizer in order to dismiss keyboar when tap outside fields
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    
}

-(void)dismissKeyboard{
    [self.name resignFirstResponder];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    

    [self.scrollview setContentOffset:CGPointZero animated:NO];
    
}
- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.scrollview.contentSize = self.view.bounds.size;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.scrollview.contentSize = self.view.bounds.size;
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGPoint buttonOrigin = self.name.frame.origin;
    
    CGFloat buttonHeight = self.name.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)){
        
        CGPoint scrollPoint = CGPointMake(0.0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        
        [self.scrollview setContentOffset:scrollPoint animated:YES];
        
    }
    
}

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

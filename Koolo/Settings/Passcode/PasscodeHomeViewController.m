//
//  PasscodeHomeViewController.m
//  Koolo
//
//  Created by Hamsini on 26/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "PasscodeHomeViewController.h"
#import "PassCodeViewController.h"
#import "ViewController.h"

@interface PasscodeHomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    
    NSArray *secretQuestions;
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;
@property (weak, nonatomic) IBOutlet UITextField *pickerViewTextField;
@property (strong, nonatomic) NSString *secretQuestion;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UILabel *activateLabel;
@property (weak, nonatomic) IBOutlet UIButton *setPasscodeButton;
@property (weak, nonatomic) IBOutlet UILabel *secretQuestionLabel;

@end

@implementation PasscodeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    
    if ([language isEqualToString:@"nb"]) {
        
        self.title = NSLocalizedString(@"Passcode", nil);
        self.secretQuestion = NSLocalizedString(@"Set secretQuestion", nil);
        self.activateLabel.text = NSLocalizedString(@"Active Passcode", nil);
        [self.setPasscodeButton setTitle:NSLocalizedString(@"Set Passcode", nil) forState:UIControlStateNormal];
        self.secretQuestionLabel.text = NSLocalizedString(@"Set secretQuestion", nil);
        self.pickerViewTextField.text= NSLocalizedString(@"Select secretQuestion", nil);
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        
        
    } else {
        self.title = @"Passcode";
        self.secretQuestion = @"Select your secret question";
        self.activateLabel.text = @"Activate/Deactivate Passcode";
       [self.setPasscodeButton setTitle:@"Set Passcode" forState:UIControlStateNormal];
        self.secretQuestionLabel.text = @"Set secretQuestion";
        self.pickerViewTextField.text = @"Select your secret question";
        cancelTitle = @"Cancel";
        doneButtonTitle = @"Finished";
    }
   
    selectedIndex = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isPassCodeOn"]) {
        
        [_passSwitch setOn:YES animated:YES];
        
    } else{
        [_passSwitch setOn:NO animated:YES];
        
    }
    
    NSString *secretQuestion = (NSString *)[defaults objectForKey:@"secretQuestion"];
    if (secretQuestion.length) {
        
        self.secretQuestion = secretQuestion;
        self.pickerViewTextField.text = secretQuestion;
        self.answerField.text = [defaults objectForKey:@"secretAnswer"];
        self.answerField.hidden = NO;
        
    } else {
        
        self.answerField.hidden = YES;
    }
    
    secretQuestions = [[NSArray alloc] initWithObjects:@"What is your favourite color?", @"What is your pet name?", @"Who's your favourite actor?", @"What is your first car?", @"What is your favourite food? ", nil];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = pickerView;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToPasscode)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - IBAction methods

-(IBAction)changeSwitch:(UISwitch*)passSwitch {

    [[NSUserDefaults standardUserDefaults] setBool:passSwitch.isOn forKey:@"isPassCodeOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!passSwitch.isOn) {
        
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = nil;
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        ViewController *rootViewController = (ViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"HomeScreen"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        window.rootViewController = navigationController;
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (IBAction)setPasscode:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    PassCodeViewController *passCodeViewController = (PassCodeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PasscodeController"];
    [passCodeViewController setMode:1];
    [self.navigationController pushViewController:passCodeViewController animated:YES];
}
- (IBAction)showSecretQuestions:(id)sender {
    
    [self.pickerViewTextField becomeFirstResponder];
}

# pragma mark - UIPickerView methods

- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    
    [self.pickerViewTextField resignFirstResponder];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    self.pickerViewTextField.text = [secretQuestions objectAtIndex:selectedIndex];
    self.answerField.hidden = NO;
    // hide the picker view
    [[NSUserDefaults standardUserDefaults] setObject:self.pickerViewTextField.text forKey:@"secretQuestion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.pickerViewTextField resignFirstResponder];
    
    // perform some action
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [secretQuestions count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *item = [secretQuestions objectAtIndex:row];
    
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    selectedIndex = row;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([self.answerField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:@"Answer field should not be empty." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.answerField.text forKey:@"secretAnswer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.answerField resignFirstResponder];
    }
    
    
    return YES;
}

#pragma mark - User defined mehtods

- (void)cancelScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moveToPasscode {
    
    if (![self.answerField isHidden]) {
        if ([self.answerField.text isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:@"Answer field should not be empty." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:self.answerField.text forKey:@"secretAnswer"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

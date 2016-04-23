//
//  PassCodeViewController.m
//  Koolo
//
//  Created by Vinodram on 09/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "PassCodeViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface PassCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *passcodeField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *passWordFields;
@end

@implementation PassCodeViewController

- (void)viewDidLoad {
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    passCodeString = @"";
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        self.title = NSLocalizedString(@"Passcode", nil);
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        wrongCodeMessage = NSLocalizedString(@"Wrong code", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
    } else {
        self.title = @"Passcode";
        cancelTitle = @"Cancel";
        wrongCodeMessage = @"Wrong Code";
        doneButtonTitle = @"Done";
    }
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    self.passcodeField.keyboardType = UIKeyboardTypeNumberPad;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    secretQuestion = (NSString *)[defaults objectForKey:@"secretQuestion"];
    secretAnswer = (NSString *)[defaults objectForKey:@"secretAnswer"];
    
    NSDictionary* barButtonItemAttributes =
    @{NSFontAttributeName:
          [UIFont fontWithName:@"Klavika-Regular" size:20.0f],
      NSForegroundColorAttributeName:
          [UIColor blackColor]
      };
    
    if (self.mode == 1) {
        UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
        [leftButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(savePassword)];
    [rightButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [super viewDidLoad];
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // create vibrancy effect
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    // add blur to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add vibrancy to yet another effect view
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    vibrantView.frame = self.view.frame;
    effectView.alpha = 0.9;
    vibrantView.alpha = 0.9;
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    // Do any additional setup after loading the view.
    [self.passcodeField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    
    wrongCount = 0;
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self drawTextFields:passCodeString];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL status = YES;
    
    NSString *totalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    int length = (int)(totalString.length);
    if (length > 4) {
        
        status = NO;
        
        
    }else{
        passCodeString = @"";
        passCodeString = totalString;
        [self drawTextFields:totalString];
        
        if (length == 4) {
            
            if (self.mode == 1) {
                
                //[self savePassword:totalString];
                
            }
            else{
                
                //[self checkPassWord:totalString];
                status = NO;
            }
        }
        
    }
    
    
    
    return status;
    
}

-(void)drawTextFields:(NSString*)totalString
{
    
    int length = (int)(totalString.length);
    
    for (int i=0; i < [self.passWordFields count]; i++) {
        
        UIView *view = (UIView*)[self.passWordFields objectAtIndex:i];
        
        if (length >= i+1) {
            
            [view.layer setMasksToBounds:YES];
            [view.layer setCornerRadius:view.frame.size.width/2];
            [view.layer setBorderWidth:2.0];
            [view.layer setBorderColor:[UIColor whiteColor].CGColor];
            [view setBackgroundColor:[UIColor colorWithRed:64.0/255.0 green:148.0/255.0 blue:113.0/255.0 alpha:1.0]];
            
        }
        else{
            
            
            [view.layer setMasksToBounds:YES];
            [view.layer setCornerRadius:view.frame.size.width/2];
            [view.layer setBorderColor:[UIColor clearColor].CGColor];
            [view setBackgroundColor:[UIColor whiteColor]];

        }
        
        
    }
    
    
}

#pragma mark - User defined mehtods

- (void)cancelScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)savePassword
{
    
    if (passCodeString.length == 4) {
    
        if (self.mode == 1) {
            
            [[NSUserDefaults standardUserDefaults] setObject:passCodeString forKey:@"Password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            [self checkPassWord:passCodeString];
        }
        
    } else {
        [self.passcodeField resignFirstResponder];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:@"The passcode  should be a 4 digit number" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self.passcodeField becomeFirstResponder];
                                       
                                   }];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (void)popToPreviousScreen {
    
    
}

-(void)checkPassWord:(NSString*)passString
{
    
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    
    if ([passWord isEqualToString:passString]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"isPassCodeOn"] && [[defaults objectForKey:@"Password"] length]) {
            
            AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"]];
            appdelegate.window.rootViewController = navigationController;
        }
        
        
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"] animated:YES];
        
        
    }
    else{
        
        
        if (secretQuestion.length && secretAnswer.length) {
            ++wrongCount;
        }
        
        
        if (wrongCount == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"SecretAnswer"] animated:YES];
        } else {
            UIAlertView *errorAlert =[[UIAlertView alloc] initWithTitle:@"Koolo" message:wrongCodeMessage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [errorAlert show];
            
            [self.passcodeField setText:@""];
            [self drawTextFields:@""];
        }
        
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

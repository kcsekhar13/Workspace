//
//  PassCodeViewController.m
//  Koolo
//
//  Created by Vinodram on 09/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "PassCodeViewController.h"

@interface PassCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *passcodeField;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *passWordFields;
@end

@implementation PassCodeViewController

- (void)viewDidLoad {
    self.title = @"Passcode";
    [super viewDidLoad];
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
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
    
    [self drawTextFields:nil];
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
        
        
        [self drawTextFields:totalString];
        
        if (length == 4) {
            
            if (self.mode == 1) {
                
                [self savePassword:totalString];
                
            }
            else{
                
                [self checkPassWord:totalString];
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

-(void)savePassword:(NSString*)passString
{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:passString forKey:@"Password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)checkPassWord:(NSString*)passString
{
    
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"Password"];
    
    if ([passWord isEqualToString:passString]) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"] animated:YES];
        
        
    }
    else{
        ++wrongCount;
        
        if (wrongCount == 3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"SecretAnswer"] animated:YES];
        } else {
            UIAlertView *errorAlert =[[UIAlertView alloc] initWithTitle:@"Koolo" message:@"Wrong Code" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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

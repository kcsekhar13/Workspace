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

@interface PasscodeHomeViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;

@end

@implementation PasscodeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"isPassCodeOn"]) {
        
        [_passSwitch setOn:YES animated:YES];
        
    } else{
        [_passSwitch setOn:NO animated:YES];
        
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

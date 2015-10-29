//
//  MSPreViewViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MSPreViewViewController.h"
#import "MSColorPickerViewController.h"

@interface MSPreViewViewController ()

@end

@implementation MSPreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"enableCamera"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)colorSelection:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MSColorPickerScreen"] animated:YES];
}

- (IBAction)moveToMoodLineScreen:(id)sender  {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MoodLineScreen"] animated:YES];
}

@end

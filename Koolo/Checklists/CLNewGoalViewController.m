//
//  CLNewGoalViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CLNewGoalViewController.h"

@interface CLNewGoalViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *goalTextView;

@end

@implementation CLNewGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"New Goal";
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Add On" style:UIBarButtonItemStylePlain target:self action:@selector(addOn)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(previousScreen)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.goalTextView.text = @"New goal";
    self.goalTextView.textColor = [UIColor lightGrayColor];
    [self.goalTextView.layer setMasksToBounds:YES];
    [self.goalTextView.layer setBorderWidth:2.0];
    [self.goalTextView.layer setBorderColor:[UIColor grayColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView delegateMethods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.goalTextView.text = @"";
    self.goalTextView.textColor = [UIColor blackColor];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
        
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

#pragma mark -  User defined methods

- (void)addOn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)previousScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
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

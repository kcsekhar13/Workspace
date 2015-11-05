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
    
    self.title = _titleString;
    newGoalFlag = NO;
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
    
    self.goalTextView.text = _titleString;
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
    newGoalFlag = YES;
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
    
    if (((self.goalTextView.text.length == 0) || !newGoalFlag)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:@"Textview field should not be empty." preferredStyle:UIAlertControllerStyleAlert];
        
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
        if ([self.delegate respondsToSelector:@selector(addNewgoalWithText:)]) {
            [self.delegate addNewgoalWithText:self.goalTextView.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)previousScreen {
    
    [self.goalTextView resignFirstResponder];
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

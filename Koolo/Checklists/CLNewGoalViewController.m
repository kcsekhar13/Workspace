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
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        doneButtonTitle = NSLocalizedString(@"Add", nil);
        
        
    } else {
        cancelTitle = @"Cancel";
        doneButtonTitle = @"Add On";
    }
    
    newGoalFlag = YES;
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
    
    NSDictionary* barButtonItemAttributes =
    @{NSFontAttributeName:
          [UIFont fontWithName:@"Klavika-Regular" size:20.0f],
      NSForegroundColorAttributeName:
          [UIColor blackColor]
      };
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(addOn)];
    [doneButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(previousScreen)];
    [cancelButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    if (self.editFlag) {
        self.goalTextView.text = [NSString stringWithFormat:@"%@", [self.editDict objectForKey:@"GoalText"]];
    } else {
        self.goalTextView.text = _titleString;
    }
    
    self.goalTextView.textColor = [UIColor blackColor];
    [self.goalTextView.layer setMasksToBounds:YES];
    [self.goalTextView.layer setBorderWidth:2.0];
    [self.goalTextView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextView delegateMethods

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.editFlag) {
         self.goalTextView.text = @"";
    }
   
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
        
        NSString *errorMessage = nil;
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
            
            errorMessage = NSLocalizedString(@"Textfield warning", nil);
            
        } else {
            
            errorMessage = @"Textview field should not be empty.";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
        
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
        if (self.editFlag) {
            if ([self.delegate respondsToSelector:@selector(updateGoalWithText: withIndexValue:)]) {
                [self.editDict setObject:self.goalTextView.text forKey:@"GoalText"];
                [self.delegate updateGoalWithText:self.editDict withIndexValue:_indexValue];
            }
        } else {
            
            if ([self.delegate respondsToSelector:@selector(addNewgoalWithText:)]) {
                [self.delegate addNewgoalWithText:self.goalTextView.text];
            }
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

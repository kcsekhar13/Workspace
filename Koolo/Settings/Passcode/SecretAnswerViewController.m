//
//  SecretAnswerViewController.m
//  Koolo
//
//  Created by Hamsini on 04/11/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "SecretAnswerViewController.h"

@interface SecretAnswerViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionTitle;

@end

@implementation SecretAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *cancelTitle = nil;
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        
        self.title = NSLocalizedString(@"SecurityAnswerTitle", nil);
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        self.questionTitle.text = NSLocalizedString(@"Answer Secutiry question", nil);
        
    } else {
        self.title = @"Security Answer";
        cancelTitle = @"Cancel" ;
        self.questionTitle.text = @"Answer Security question";
    }
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *secretQuestion = (NSString *)[defaults objectForKey:@"secretQuestion"];
    if (secretQuestion.length) {
        self.questionLabel.text = secretQuestion;
    }
    dataManager = [StoreDataMangager sharedInstance];
    /*
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }*/
    
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
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    NSDictionary* barButtonItemAttributes =
    @{NSFontAttributeName:
          [UIFont fontWithName:@"Klavika-Regular" size:20.0f],
      NSForegroundColorAttributeName:
          [UIColor blackColor]
      };
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [cancelButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextfield delegate Methods 

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSString *answerString = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"secretAnswer"];
    if ([self.answerTextField.text isEqualToString:answerString]) {
        
        [textField resignFirstResponder];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"HomeScreen"] animated:YES];
        
    } else {
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *errorMessage = nil;
        if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
            
            errorMessage = NSLocalizedString(@"Wrong answer", nil);
            
        } else {
            errorMessage = @"Entered wrong answer.";
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
    }
    return YES;
}

#pragma mark - User defined mehtods
- (void)cancelScreen {
    
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

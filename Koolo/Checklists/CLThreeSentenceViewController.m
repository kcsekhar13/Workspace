//
//  CLThreeSentenceViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CLThreeSentenceViewController.h"

@interface CLThreeSentenceViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextView *questionOneTextView;
@property (weak, nonatomic) IBOutlet UITextView *questionTwoTextView;
@property (weak, nonatomic) IBOutlet UITextView *questionThreeTextView;
@property (weak, nonatomic) UITextView *selectedTextView;
@property (nonatomic, strong) UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UILabel *question_OneLabel;
@property (weak, nonatomic) IBOutlet UILabel *question_TwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *question_ThreeLabel;

@end

@implementation CLThreeSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationFlag = YES;
    // Do any additional setup after loading the view.
    
    viewFrame = self.view.frame;
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.statusBarView.backgroundColor = [UIColor whiteColor];
    self.statusBarView.alpha = 0.0;
    [self.view addSubview:self.statusBarView];
    
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        
        self.question_OneLabel.text = [NSString stringWithFormat:@"1. %@", NSLocalizedString(@"Question1", nil)];
        self.question_TwoLabel.text = [NSString stringWithFormat:@"2. %@", NSLocalizedString(@"Question2", nil)];
        self.question_ThreeLabel.text = [NSString stringWithFormat:@"3. %@", NSLocalizedString(@"Question3", nil)];
        self.title = NSLocalizedString(@"Three sentences", nil);
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
    } else {
        self.title = @"Three sentences";
        self.question_OneLabel.text = [NSString stringWithFormat:@"1. %@", @"My age, diagnosis and brief medical history"];
        self.question_TwoLabel.text = [NSString stringWithFormat:@"2. %@", @"My treatment plan"];
        self.question_ThreeLabel.text = [NSString stringWithFormat:@"3. %@", @"My question/concern to talk about during the visit"];
        cancelTitle = @"Cancel";
        doneButtonTitle = @"Done";
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
    effectView.alpha = 0.65;
    vibrantView.alpha = 0.45;
    [vibrantView setBackgroundColor:[UIColor blackColor]];
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(doneWithThreeSentences)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(previousScreen)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    UIButton *kbDoneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [kbDoneButton setFrame: CGRectMake(self.view.frame.size.width - 80.0, 0.0, 80.0, 40.0)];
    // Title.
    [kbDoneButton setTitle: @"Done" forState: UIControlStateNormal];
    // Background color.
    [kbDoneButton setBackgroundColor: [UIColor blueColor]];
    
    [kbDoneButton addTarget: self action: @selector(resignTextView) forControlEvents: UIControlEventTouchUpInside];
    
   
    [inputAccView addSubview:kbDoneButton];
    self.selectedTextView = self.questionOneTextView;
    self.questionOneTextView.inputAccessoryView = inputAccView;
    self.questionTwoTextView.inputAccessoryView = inputAccView;
    self.questionThreeTextView.inputAccessoryView = inputAccView;
    
    [self.questionOneTextView.layer setMasksToBounds:YES];
    [self.questionOneTextView.layer setBorderWidth:2.0];
    [self.questionOneTextView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [self.questionTwoTextView.layer setMasksToBounds:YES];
    [self.questionTwoTextView.layer setBorderWidth:2.0];
    [self.questionTwoTextView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [self.questionThreeTextView.layer setMasksToBounds:YES];
    [self.questionThreeTextView.layer setBorderWidth:2.0];
    [self.questionThreeTextView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"threeSentence"];
    
    if (dict == nil) {
        self.questionOneTextView.text = @"";
        self.questionTwoTextView.text = @"";
        self.questionThreeTextView.text = @"";
    } else {
        self.questionOneTextView.text = dict[@"SentenceOne"];
        self.questionTwoTextView.text = dict[@"SentenceTwo"];
        self.questionThreeTextView.text = dict[@"SentenceThree"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView delegateMethods

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.selectedTextView = textView;
    if (textView == self.questionTwoTextView ) {
        
        CGRect frame = self.view.frame;
        frame.origin.y = -80;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
            
            [self.statusBarView setFrame:CGRectMake(0, 80, self.view.frame.size.width, 20)];
            [self.statusBarView setAlpha:1.0];
        }];
    } else if (textView == self.questionThreeTextView ) {
        
        CGRect frame = self.view.frame;
        frame.origin.y = -250;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
            
            [self.statusBarView setFrame:CGRectMake(0, 250, self.view.frame.size.width, 20)];
            [self.statusBarView setAlpha:1.0];
        }];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    CGRect frame = viewFrame;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = viewFrame;
        
        [self.statusBarView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [self.statusBarView setAlpha:0.0];
    }];
}

#pragma mark -  User defined methods

- (void)doneWithThreeSentences {
    
    if (self.questionOneTextView.text.length == 0) {
        self.questionOneTextView.text = @"";
    }
    
    if (self.questionTwoTextView.text.length == 0) {
        self.questionTwoTextView.text = @"";
    }
    
    if (self.questionThreeTextView.text.length == 0) {
        self.questionThreeTextView.text = @"";
    }
    
    NSDictionary *threeSentenceDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.questionOneTextView.text,@"SentenceOne", self.questionTwoTextView.text,@"SentenceTwo", self.questionThreeTextView.text,@"SentenceThree", nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:threeSentenceDict forKey:@"threeSentence"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)previousScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resignTextView {
    
    [self.selectedTextView resignFirstResponder];
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

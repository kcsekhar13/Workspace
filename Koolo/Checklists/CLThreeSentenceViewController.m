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

@end

@implementation CLThreeSentenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    animationFlag = YES;
    // Do any additional setup after loading the view.
    self.title = @"Three sentences";
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
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Finished" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithColorSelection)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(previousScreen)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)];
    
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    UIButton *kbDoneButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [kbDoneButton setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    // Title.
    [kbDoneButton setTitle: @"Done" forState: UIControlStateNormal];
    // Background color.
    [kbDoneButton setBackgroundColor: [UIColor blueColor]];
    
    [kbDoneButton addTarget: self action: @selector(resignTextView) forControlEvents: UIControlEventTouchUpInside];
    
   
    [inputAccView addSubview:kbDoneButton];
    self.selectedTextView = self.questionOneTextView;
    self.questionOneTextView.inputAccessoryView = inputAccView;
    self.questionTwoTextView.inputAccessoryView = inputAccView;;
    self.questionThreeTextView.inputAccessoryView = inputAccView;;
    
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

- (void)doneWithColorSelection {
    
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

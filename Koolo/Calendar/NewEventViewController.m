//
//  NewEventViewController.m
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
@property (weak, nonatomic) IBOutlet UITextField *addTagField;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    NSString *cancelButtonTitle = nil;
    
    if ([language isEqualToString:@"nb"]) {
        
        self.title = NSLocalizedString(@"Today's Event", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        
    } else {
        self.title = @"Today's Event";
        doneButtonTitle = @"Finished";
        cancelButtonTitle = @"Cancel";
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToCalendarScreen)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToCalendarScreen)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE"];
    
    NSString *textString = [NSString stringWithFormat:@"%@ \n%@", [dateFormatter stringFromDate:self.selectedDate], [dayFormatter stringFromDate:self.selectedDate]];
    
    [_mDayLabel setText:textString];
    [_mDayLabel setNumberOfLines:2];
    [_mDayLabel setTextAlignment:NSTextAlignmentCenter];
    [_mDayLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_mDayLabel setBackgroundColor:[UIColor grayColor]];
    [_mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [_mDayLabel.layer setBorderWidth:2.0f];
    [_mDayLabel.layer setMasksToBounds:YES];
    [_mDayLabel.layer setCornerRadius:30.0f];
    [_mDayLabel setUserInteractionEnabled:YES];
    
    NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM yyyy"];
    self.monthLabel.text = [monthFormatter stringFromDate:self.selectedDate];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake((self.addTagField.frame.origin.x + self.addTagField.frame.size.width) - 10.0f, 1.0, 14.0, 14.0)];
    [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    
    self.addTagField.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [self.addTagField setRightView:clearButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegateMethods

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
   
    return YES;
}

- (void)clearTextField {
    self.addTagField.text = @"";
}
- (void)moveToCalendarScreen {
    
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

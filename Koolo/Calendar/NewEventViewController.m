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
@property (strong, nonatomic)UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *remainderLabel;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    NSString *cancelButtonTitle = nil;
    
    if ([language isEqualToString:@"nb"]) {
        
        self.title = NSLocalizedString(@"Today's Event", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        
    } else {
        self.title = @"Today's Event";
        doneButtonTitle = @"Done";
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
    
    dataManager = [StoreDataMangager sharedInstance];
    
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
    
    /*
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeButton setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
    [timeButton setFrame:CGRectMake( 5.0f, 1.0, 14.0, 14.0)];
    [timeButton addTarget:self action:@selector(launchDatePicker) forControlEvents:UIControlEventTouchUpInside];
    self.datePickerField.leftViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [self.datePickerField setLeftView:timeButton];*/
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height + 190.0f, self.view.frame.size.width, 200.0f)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setBackgroundColor:[UIColor blackColor]];
     [_datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    [self.view addSubview:self.datePicker];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.datePicker.frame.origin.y - 44.0f, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem* dailyButton = [[UIBarButtonItem alloc] initWithTitle:@"Daily" style:UIBarButtonItemStylePlain target:self action:@selector(selectRemainderType:)];
     UIBarButtonItem* flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* weeklyButton = [[UIBarButtonItem alloc] initWithTitle:@"Weekly" style:UIBarButtonItemStylePlain target:self action:@selector(selectRemainderType:)];
    UIBarButtonItem* flexSpace3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* monthlyButton = [[UIBarButtonItem alloc] initWithTitle:@"Monthly" style:UIBarButtonItemStylePlain target:self action:@selector(selectRemainderType:)];
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* yearButton = [[UIBarButtonItem alloc] initWithTitle:@"Yearly" style:UIBarButtonItemStylePlain target:self action:@selector(selectRemainderType:)];
    dailyButton.tag = 0;
    weeklyButton.tag = 1;
    monthlyButton.tag = 2;
    yearButton.tag = 3;
    flexSpace.tag = -1;
    flexSpace2.tag = -1;
    flexSpace3.tag = -1;
    [toolBar setItems:[NSArray arrayWithObjects:dailyButton, flexSpace2, weeklyButton, flexSpace3,monthlyButton,flexSpace, yearButton,nil]];
    [self.view addSubview:toolBar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"]) {
        int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
        _mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
    } else {
        [_mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    }
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (displayDatePicker) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.datePicker setFrame:CGRectMake(0.0f, self.view.frame.size.height + 200.0f, self.view.frame.size.width, 200.0f)];
            [toolBar setFrame:CGRectMake(0, self.datePicker.frame.origin.y - 44.0f, self.view.frame.size.width, 44)];
        }];
    }
}



#pragma mark - UIDatePicker methods

- (IBAction)launchDatePicker:(id)sender {
    
    if ([_addTagField isFirstResponder]) {
        [_addTagField resignFirstResponder];
    }
    
    if ([_eventTextField isFirstResponder]) {
        [_eventTextField resignFirstResponder];
    }
    
    displayDatePicker = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.datePicker setFrame:CGRectMake(0.0f, self.view.frame.size.height - 180.0f, self.view.frame.size.width, 200.0f)];
        [toolBar setFrame:CGRectMake(0, self.datePicker.frame.origin.y - 44.0f, self.view.frame.size.width, 44)];
    }];
}

-(void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    //self.textField.text = [self.dateFormatter stringFromDate:datePicker.date];
    NSLog(@"%@", datePicker);
}

- (void)selectRemainderType:(UIBarButtonItem *)barbutton {
    
    NSLog(@"%ld", (long)barbutton.tag);
    if (barbutton.tag != -1) {
        self.remainderLabel.text = barbutton.title;
    }
    
    displayDatePicker = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.datePicker setFrame:CGRectMake(0.0f, self.view.frame.size.height + 200.0f, self.view.frame.size.width, 200.0f)];
        [toolBar setFrame:CGRectMake(0, self.datePicker.frame.origin.y - 44.0f, self.view.frame.size.width, 44)];
    }];
}
#pragma mark - User defined methods

- (void)clearTextField {
    self.addTagField.text = @"";
}

- (void)moveToCalendarScreen {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moveToColorPickerScreen:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"CalendarColorPicker"] animated:YES];
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

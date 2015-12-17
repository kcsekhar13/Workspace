//
//  NewEventViewController.m
//  Koolo
//
//  Created by Hamsini on 22/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "NewEventViewController.h"
#import "CustomTagTableViewCell.h"


@interface NewEventViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UITextField *eventTextField;
@property (weak, nonatomic) IBOutlet UITextField *addTagField;
@property (strong, nonatomic)UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *remainderLabel;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (weak, nonatomic) IBOutlet UIButton *remaindButton;
@property (weak, nonatomic) IBOutlet UIView *remainderView;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    NSString *cancelButtonTitle = nil;
    
    selectedTagsArray = [[NSMutableArray alloc] initWithObjects:@"NO", @"NO", @"NO", nil];
    
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        
        self.title = NSLocalizedString(@"Today's Event", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        cancelButtonTitle = NSLocalizedString(@"Cancel", nil);
        
    } else {
        self.title = @"Today's Event";
        doneButtonTitle = @"Done";
        cancelButtonTitle = @"Cancel";
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToCalendarScreen:)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    doneButton.tag = 1;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToCalendarScreen:)];
    [cancelButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    cancelButton.tag = 2;
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
    
    //Set the customView properties
    _customView.alpha = 0.0;
    _customView.layer.cornerRadius = 5;
    _customView.layer.borderWidth = 1.5f;
    _customView.layer.masksToBounds = YES;
    _customView.hidden = YES;
    
    
    _remainderView.layer.borderWidth = 1.5f;
    _remainderView.layer.masksToBounds = YES;
    _remainderView.layer.borderColor = [[UIColor blackColor] CGColor];
    dataManager = [StoreDataMangager sharedInstance];
    
    [_mDayLabel setNumberOfLines:2];
    [_mDayLabel setTextAlignment:NSTextAlignmentCenter];
    [_mDayLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [_mDayLabel setBackgroundColor:[UIColor grayColor]];
    [_mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    [_mDayLabel.layer setBorderWidth:2.0f];
    [_mDayLabel.layer setMasksToBounds:YES];
    [_mDayLabel.layer setCornerRadius:30.0f];
    [_mDayLabel setUserInteractionEnabled:YES];
    
    [self updateDateLabels:self.selectedDate];
    
    titlesArray = [[NSArray alloc] initWithObjects:@"Toff", @"Kjipt", @"Tro", nil];
    
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake((self.addTagField.frame.origin.x + self.addTagField.frame.size.width) - 10.0f, 1.0, 14.0, 14.0)];
    [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    
    self.addTagField.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    //[self.addTagField setRightView:clearButton];
    
    /*
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeButton setImage:[UIImage imageNamed:@"time.png"] forState:UIControlStateNormal];
    [timeButton setFrame:CGRectMake( 5.0f, 1.0, 14.0, 14.0)];
    [timeButton addTarget:self action:@selector(launchDatePicker) forControlEvents:UIControlEventTouchUpInside];
    self.datePickerField.leftViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [self.datePickerField setLeftView:timeButton];*/
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height + 190.0f, self.view.frame.size.width, 200.0f)];
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    
    [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setBackgroundColor:[UIColor blackColor]];
     [_datePicker setValue:[UIColor whiteColor] forKey:@"textColor"];
    
    [_datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"en_GB"]];
    //[_datePicker setLocale:[NSLocale systemLocale]];
    
    //[_datePicker setLocale:[NSLocale systemLocale]];
    [self.view addSubview:self.datePicker];
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //_customView.frame = CGRectMake(0, 0, 0, 0);
    self.addTagField.inputView = emptyView;
    [_addTagField setTintColor:[UIColor clearColor]];
    

    
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
        
        if (index < 9 && index >=0) {
            _mDayLabel.layer.borderColor = [(UIColor *)dataManager.fetchColorsArray[index] CGColor];
        } else {
            [_mDayLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
        }
        
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
    
    if (_addTagField == textField) {
        
        if (!selectedTagFlag) {
            [selectedTagsArray removeAllObjects];
            [selectedTagsArray addObject:@"NO"];
            [selectedTagsArray addObject:@"NO"];
            [selectedTagsArray addObject:@"NO"];
            [_tagTableView reloadData];
        }
        //Display the customView with animation
        [UIView animateWithDuration:0.6 animations:^{
            _customView.hidden = NO;
            [_customView setAlpha:1.0];
        } completion:^(BOOL finished) {}];
    } else {
        //Display the customView with animation
        [UIView animateWithDuration:0.6 animations:^{
            _customView.hidden = YES;
            [_customView setAlpha:0.0];
        } completion:^(BOOL finished) {}];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -  UITableView dataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomTagTableViewCell *cell = (CustomTagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomTagCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", titlesArray[indexPath.row]];
    
    if (cell.checkImageView.image && [selectedTagsArray[indexPath.row] isEqualToString:@"YES"]) {
        cell.checkImageView.image = [UIImage imageNamed:@"checked"];
    } else {
        cell.checkImageView.image = nil;
    }
    return cell;
}

#pragma mark -  UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTagTableViewCell *cell = (CustomTagTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.checkImageView.image) {
        cell.checkImageView.image = nil;
        [selectedTagsArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
    } else {
        cell.checkImageView.image = [UIImage imageNamed:@"checked"];
        [selectedTagsArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
        
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
    
    [self updateDateLabels:_datePicker.date];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];

    self.addTagField.text = [NSString stringWithFormat:@"Kl. %@", [dateFormatter stringFromDate:_datePicker.date]];
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

- (void)moveToCalendarScreen:(id)sender {
    
    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
    
    if (buttonItem.tag == 1) {
        
        if (self.eventTextField.text.length == 0) {
            
            [self displayErrorMessageView:@"Event Field should not be empty"];
            return;
        }
        
        if (self.remainderLabel.text.length == 0) {
            
            [self displayErrorMessageView:@"Select appointment time"];
            return;
        }
        
        NSMutableDictionary *eventDict = [[NSMutableDictionary alloc] init];
        [eventDict setObject:[NSString stringWithFormat:@"%d", remaindFlag] forKey:@"RemainderFlag"];
        
        int index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"calendarColorIndex"] intValue];
        
        if (index < 9 && index >=0) {
            [eventDict setObject:[NSString stringWithFormat:@"%d", index] forKey:@"ColorIndex"];
        } else {
            index = -1;
            [eventDict setObject:[NSString stringWithFormat:@"%d", index] forKey:@"ColorIndex"];
        }
        
        [eventDict setObject:self.eventTextField.text forKey:@"EventTitle"];
        [eventDict setObject:self.addTagField.text forKey:@"TagTitle"];
        [eventDict setObject:_selectedDate forKey:@"EventDate"];
        [eventDict setObject:selectedTagsArray forKey:@"SelectedTags"];
        NSLog(@"Event Dict = %@", eventDict);
        [[AppDataManager sharedInstance] createEventWithDetails:eventDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)updateDateLabels:(NSDate *)formattingDate {
    
    _selectedDate = formattingDate;
    _mDayLabel.text = @"";
    self.monthLabel.text = @"";
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE"];
    
    NSString *textString = [NSString stringWithFormat:@"%@ \n%@", [dateFormatter stringFromDate:formattingDate], [dayFormatter stringFromDate:formattingDate]];
    [_mDayLabel setText:textString];
    NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MMM yyyy"];
    self.monthLabel.text = [monthFormatter stringFromDate:formattingDate];
}

- (void)displayErrorMessageView:(NSString *)errorMsg {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Koolo" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    
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
#pragma mark - IBAction methods

- (IBAction)moveToColorPickerScreen:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"CalendarColorPicker"] animated:YES];
}

- (IBAction)remaindNotification:(UIButton *)sender {
    
    if (!remaindFlag) {
        [sender setBackgroundImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        remaindFlag = YES;
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        remaindFlag = NO;
    }
}

- (IBAction)dismissCustomView:(id)sender {
    
    selectedTagFlag = YES;
    //Hide the customView with animation
    [UIView animateWithDuration:0.6 animations:^{
        _customView.hidden = YES;
        [_customView setAlpha:0.0];
    } completion:^(BOOL finished) {}];
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

//
//  QuotesViewController.m
//  Koolo
//
//  Created by Vinodram on 09/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "QuotesViewController.h"
#import "QuotesTableviewCell.h"

static NSIndexPath *previousSelctedIndexPath = nil;

@interface QuotesViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property(nonatomic, weak) IBOutlet UILabel *mNoteTextField;
@property(nonatomic, weak) IBOutlet UILabel *mTypeStatusLabel;
@property(nonatomic, weak) IBOutlet UISwitch *mEnableSwitch;
@property(nonatomic, weak) IBOutlet UITableView *mQuotesTableview;
@property(nonatomic, weak) IBOutlet UITextView *mEditTextView;
@property(nonatomic, strong) NSMutableArray *mQuotesArray;
@property(nonatomic, strong) NSMutableString *mQuoteString;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) UIView *statusBarView;
- (IBAction)hideAndShowQuotes:(id)sender;
- (IBAction)addQuotes:(id)sender;

@end

@implementation QuotesViewController

- (void)viewDidLoad {

    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *rightButtonTile = nil;
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        
        self.title = @"Sitater";
        rightButtonTile = NSLocalizedString(@"Done", nil);
        
    } else {
        self.title = @"Quotes";
        rightButtonTile = @"Done";
    }
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTile style:UIBarButtonItemStylePlain target:self action:@selector(backToScreen)];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.mQuotesTableview setTableFooterView:v];
    [self.mQuotesTableview flashScrollIndicators];
    quotesFlag = (BOOL)[[NSUserDefaults standardUserDefaults] boolForKey:@"showQuotes" ];
    [self.mEnableSwitch setOn:quotesFlag animated:NO];
    // Do any additional setup after loading the view.
    [self initUI];
    _mQuotesTableview.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    
    viewFrame = self.view.frame;
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    self.statusBarView.backgroundColor = [UIColor whiteColor];
    self.statusBarView.alpha = 0.0;
    [self.view addSubview:self.statusBarView];
    
    [super viewDidLoad];
    
}

-(void)initUI {
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]) {
        
        [_mNoteTextField setText:NSLocalizedString(@"Enable Status", nil)];
        [_mTypeStatusLabel setText:NSLocalizedString(@"Add", nil)];
        
    } else {
        
        [_mNoteTextField setText:@"Enable quotes in home screen"];
        [_mTypeStatusLabel setText:@"Add"];
    }
    
    [_mNoteTextField setTextColor:[UIColor grayColor]];
    [_mEnableSwitch setSelected:TRUE]; // Set Default to TRUE.
   
    [_mTypeStatusLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [_mTypeStatusLabel setHidden:TRUE];
    [_addButton setHidden:TRUE];
    [_mQuotesTableview setSeparatorColor:[UIColor clearColor]];
    
    [_mEditTextView.layer setMasksToBounds:TRUE];
    [_mEditTextView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [_mEditTextView.layer setCornerRadius:2.0f];
    [_mEditTextView.layer setBorderWidth:1.0f];
    
    
    previousSelctedIndexPath = [NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults]  objectForKey:@"SelectedIndex"] intValue] inSection:0];
    
    if(_mQuotesArray == nil) {
        _mQuotesArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"Quotes"]];    }
    if(_mQuotesArray.count>0) {
        [_mQuotesTableview reloadData];
    }
    

}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource and Delegate methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_mQuotesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     QuotesTableviewCell *tableViewCell = (QuotesTableviewCell *)[tableView dequeueReusableCellWithIdentifier:@"QuotesCell"];
    
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableViewCell.mQuoteText setText:_mQuotesArray[indexPath.row]];
    [tableViewCell.mCheckImageView setImage:nil];
    
        
    if(previousSelctedIndexPath.row == indexPath.row) {
        
        [tableViewCell.mCheckImageView setImage:[UIImage imageNamed:@"checked"]];
        previousSelctedIndexPath = indexPath;
        [[NSUserDefaults standardUserDefaults] setObject:_mQuotesArray[indexPath.row] forKey:@"SelectedQuote"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {
        
        
        [tableViewCell.mCheckImageView setImage:nil];
        
    }
    /*
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteGuesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [tableViewCell.contentView addGestureRecognizer:swipeGesture];*/
    tableViewCell.contentView.tag = indexPath.row;
    
    return tableViewCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_mQuotesArray.count == 1 || indexPath.row == 0) {
        
        return NO;
    } else {
        return YES;
    }
    
    
    

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (previousSelctedIndexPath.row > 0) {
        
        previousSelctedIndexPath = [NSIndexPath indexPathForRow:previousSelctedIndexPath.row-1 inSection:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)previousSelctedIndexPath.row] forKey:@"SelectedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_mQuotesArray removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:_mQuotesArray forKey:@"Quotes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_mQuotesTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_mQuotesTableview reloadData];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Delete";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set Selected Cell.
    
    
    QuotesTableviewCell *selectedCell = nil;
    QuotesTableviewCell *unSelectedCell = nil;
    
    if(previousSelctedIndexPath != indexPath) {
        selectedCell = (QuotesTableviewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [selectedCell.mCheckImageView setImage:[UIImage imageNamed:@"checked"]];
        
        [[NSUserDefaults standardUserDefaults] setObject:_mQuotesArray[indexPath.row] forKey:@"SelectedQuote"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Set unselected Cell.
        unSelectedCell = (QuotesTableviewCell *) [tableView cellForRowAtIndexPath:previousSelctedIndexPath];
        unSelectedCell.mCheckImageView.image = nil;
        //[unSelectedCell.mCheckImageView setImage:[UIImage imageNamed:@"unchecked"]];
    }
    previousSelctedIndexPath = indexPath;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"SelectedIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - UITextView delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = self.view.frame;
    frame.origin.y = -253;
     _mQuoteString = [[NSMutableString alloc] init];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = frame;
        
        [self.statusBarView setFrame:CGRectMake(0, 253, self.view.frame.size.width, 20)];
        [self.statusBarView setAlpha:1.0];
        
        if ([textView isEqual:_mEditTextView]) {
            [textView setText:nil];
            [_mEditTextView setFrame:CGRectMake(_mEditTextView.frame.origin.x, _mEditTextView.frame.origin.y, _mEditTextView.frame.size.width, 90)];
            [UIView commitAnimations];
            [_mTypeStatusLabel setHidden:FALSE];
            [_addButton setHidden:FALSE];
        }
    }];

   
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return TRUE;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return TRUE;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect frame = viewFrame;
    frame.origin.y = self.navigationController.navigationBar.frame.size.height + 20;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = viewFrame;
        
        [self.statusBarView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        [self.statusBarView setAlpha:0.0];
        
        if ([textView isEqual:_mEditTextView]) {
            [_mTypeStatusLabel setHidden:TRUE];
            [_addButton setHidden:TRUE];
            [textView setText:nil];
            [_mEditTextView setFrame:CGRectMake(_mEditTextView.frame.origin.x, _mEditTextView.frame.origin.y, _mEditTextView.frame.size.width, 44)];
        }
        
    }];
    
    
    [_mQuotesArray addObject:_mQuoteString];
    [_mQuotesTableview reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:_mQuotesArray forKey:@"Quotes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL status = TRUE;
    
    // Any new character added is passed in as the "text" parameter
    [_mQuoteString appendString:text];
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        status = FALSE;
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return status;
}


#pragma mark - IBAction Methods

- (IBAction)hideAndShowQuotes:(id)sender {
    
//    UISwitch *enableSwitch = (UISwitch *)sender;
//    
//    if(enableSwitch.enabled) {
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showQuotes"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    } else {
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showQuotes"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
    if (quotesFlag) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"showQuotes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        quotesFlag = NO;
    } else {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showQuotes"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        quotesFlag = YES;
    }
}

- (IBAction)addQuotes:(id)sender {
    
    [_mEditTextView resignFirstResponder];
}

-(void)deleteGuesture:(UISwipeGestureRecognizer*)swipeGesture
{
    UIView *view = swipeGesture.view;

    if (_mQuotesArray.count == 1 || (previousSelctedIndexPath == [NSIndexPath indexPathForRow:view.tag inSection:0])) {
        
        return;
    }
    
    if (previousSelctedIndexPath.row > view.tag) {
        
        previousSelctedIndexPath = [NSIndexPath indexPathForRow:previousSelctedIndexPath.row-1 inSection:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:(int)previousSelctedIndexPath.row] forKey:@"SelectedIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [_mQuotesArray removeObjectAtIndex:view.tag];
    [[NSUserDefaults standardUserDefaults] setObject:_mQuotesArray forKey:@"Quotes"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_mQuotesTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:view.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_mQuotesTableview reloadData];
}

- (void)backToScreen {
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

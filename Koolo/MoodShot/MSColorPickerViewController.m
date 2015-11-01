//
//  MSColorPickerViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MSColorPickerViewController.h"
#import "colorPickerTableViewCell.h"


@interface MSColorPickerViewController () <colorPickerTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation MSColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Color choices";
    saveFlag = NO;
    dataManager = [StoreDataMangager sharedInstance];
    colorTitlesArray = [[NSMutableArray alloc] initWithArray:dataManager.fetchColorPickerTitlesArray];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithColorSelection)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Get the size of the keyboard.
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Given size may not account for screen rotation
    int height = MIN(keyboardSize.height,keyboardSize.width) - 40.0f;
    //int width = MAX(keyboardSize.height,keyboardSize.width);
    
    self.contentTableView.frame = CGRectMake(self.contentTableView.frame.origin.x, self.contentTableView.frame.origin.y, self.contentTableView.frame.size.width, self.contentTableView.frame.size.height - height);
    
    
    [self.contentTableView scrollToRowAtIndexPath:[self.contentTableView indexPathForCell:colorCell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    int height = MIN(keyboardSize.height,keyboardSize.width) - 40.0f;
   
    [self.contentTableView setContentOffset:CGPointZero];
    
     self.contentTableView.frame = CGRectMake(self.contentTableView.frame.origin.x, 0.0, self.contentTableView.frame.size.width, self.contentTableView.frame.size.height + height);
    [self.contentTableView scrollToRowAtIndexPath:[self.contentTableView indexPathForCell:colorCell] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
#pragma mark -  UITableView dataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return colorTitlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    colorPickerTableViewCell *cell = (colorPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleTextField.text = [NSString stringWithFormat:@"%@", colorTitlesArray[indexPath.row]];
    [cell.colorKeyView.layer setBorderColor:[UIColor clearColor].CGColor];
    [cell.colorKeyView.layer setCornerRadius:cell.colorKeyView.frame.size.width/2];
    [cell.colorKeyView.layer setMasksToBounds:YES];
    cell.colorKeyView.backgroundColor = (UIColor *)dataManager.fetchColorsArray[indexPath.row];
    cell.delegate = self;
    cell.selectedColorIndex = indexPath.row;
    
    return cell;
}

#pragma mark -  colorPickerTableViewCellDelegate

- (void)adjustTableViewCellFrame:(id)sender {
    
    colorCell =  (colorPickerTableViewCell *)sender;
    
    NSLog(@"%@", [self.contentTableView indexPathForCell:colorCell]);
    
    [self.contentTableView scrollToRowAtIndexPath:[self.contentTableView indexPathForCell:colorCell] atScrollPosition:UITableViewScrollPositionTop animated:NO];

}

- (void)updateColorPickertitles:(id)sender {
    colorCell =  (colorPickerTableViewCell *)sender;
    [colorTitlesArray replaceObjectAtIndex:colorCell.selectedColorIndex withObject:colorCell.titleTextField.text];
    if (saveFlag) {
        [dataManager updateFetchColorPickerTitlesArray:colorTitlesArray];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  User defined methods

- (void)doneWithColorSelection {
//    NSIndexPath *selectedIndexPath = [self.contentTableView indexPathForSelectedRow];
//    colorPickerTableViewCell *colorCell  = [self.contentTableView cellForRowAtIndexPath:selectedIndexPath];
//    [colorTitlesArray replaceObjectAtIndex:colorCell.selectedColorIndex withObject:colorCell.titleTextField.text];
    saveFlag = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

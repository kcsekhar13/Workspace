//
//  MSColorPickerViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MSColorPickerViewController.h"
#import "colorPickerTableViewCell.h"
#import "StoreDataMangager.h"

@interface MSColorPickerViewController () <colorPickerTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@end

@implementation MSColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StoreDataMangager *dataManager = [StoreDataMangager sharedInstance];
    colorTitlesArray = [[NSMutableArray alloc] initWithArray:dataManager.fetchColorPickerTitlesArray];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.delegate = self;
    cell.selectedColorIndex = indexPath.row;
    
    return cell;
}

#pragma mark -  colorPickerTableViewCellDelegate
- (void)adjustTableViewCellFrame:(id)sender {
    
    colorPickerTableViewCell *colorCell =  (colorPickerTableViewCell *)sender;
    
    NSLog(@"%@", [self.contentTableView indexPathForCell:colorCell]);
    
    [self.contentTableView scrollToRowAtIndexPath:[self.contentTableView indexPathForCell:colorCell] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)doneWithColorSelection {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

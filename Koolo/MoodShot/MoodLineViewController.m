//
//  MoodLineViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MoodLineViewController.h"

@interface MoodLineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation MoodLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mood Line";
    dataManager = [StoreDataMangager sharedInstance];
    // Do any additional setup after loading the view.
    
    self.moodsArray = [dataManager getMoodsFromPlist];
    self.moodLineTableView.backgroundView = nil;
    self.moodLineTableView.backgroundColor = [UIColor clearColor];
    self.moodLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.moodsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *tableViewCellIdentifier = @"PreviewCell";
    MoodPreviewCell *tableViewCell = (MoodPreviewCell * )[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    NSDictionary *dict = [self.moodsArray objectAtIndex:indexPath.row];
    NSString *savedImagePath = [[dataManager getDocumentryPath] stringByAppendingPathComponent:[dict objectForKey:@"FileName"]];
    
    tableViewCell.backgroundColor = [UIColor clearColor];
    tableViewCell.moodColorImage.backgroundColor = dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]];
    
    [tableViewCell.moodColorImage.layer setBorderColor:[UIColor clearColor].CGColor];
    [tableViewCell.moodColorImage.layer setCornerRadius:tableViewCell.moodColorImage.frame.size.width/2];
    [tableViewCell.moodColorImage.layer setMasksToBounds:YES];
    tableViewCell.moodCellImage.image = [UIImage imageWithContentsOfFile:savedImagePath];

    [tableViewCell setBoarderColor:dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]]];
    
    [tableViewCell.moodCellImage.layer setMasksToBounds:YES];
    [tableViewCell.moodCellImage.layer setBorderWidth:10.0];
    [tableViewCell.moodCellImage.layer setBorderColor:((UIColor*)(dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]])).CGColor];
    [tableViewCell drawBoarderForCell];
    [tableViewCell.dateLabel setText:[dataManager getDateStringFromDate:[dict  objectForKey:@"FileName"]]];
    [tableViewCell.dateLabel setBackgroundColor:((UIColor*)(dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]]))];
    
    return tableViewCell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 251.0;
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

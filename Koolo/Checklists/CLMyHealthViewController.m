//
//  CLMyHealthViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CLMyHealthViewController.h"
#import "CLNewGoalViewController.h"
#import "CLNewGoalTableViewCell.h"
#import "AppConstants.h"

@interface CLMyHealthViewController () <NewGoalDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) NSArray *addGoalsArray;
@property (weak, nonatomic) IBOutlet UIButton *infoGoallButton;
@property (weak, nonatomic) IBOutlet UITableView *goalsTableView;

@end

@implementation CLMyHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.viewTitle;
    
    
    self.addGoalsArray = [[NSMutableArray alloc] init];
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }

    _goalsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Finished" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithColorSelection)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* newGoalButton = [[UIBarButtonItem alloc] initWithTitle:self.rightButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToNewGoalScreen)];
    [newGoalButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = newGoalButton;
    
    
    [self.infoGoallButton.layer setBorderColor:[UIColor clearColor].CGColor];
    [self.infoGoallButton.layer setCornerRadius:self.infoGoallButton.frame.size.width/2];
    [self.infoGoallButton.layer setMasksToBounds:YES];
    self.infoGoallButton.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.goalFlag) {
        self.addGoalsArray = dataManager.getMoodShotGoalsFromPlist;
    } else {
        self.addGoalsArray = dataManager.getReadyTransferDataFromPlist;
    }
    
    if (_addGoalsArray.count) {
        [_goalsTableView setHidden:NO];
        [_goalsTableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  UITableView dataSource methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _addGoalsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLNewGoalTableViewCell *cell = (CLNewGoalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GoalCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goalTextLabel.text = [NSString stringWithFormat:@"%@", _addGoalsArray[indexPath.row][@"GoalText"]];
    [cell.goalCellImage.layer setBorderColor:[UIColor clearColor].CGColor];
    [cell.goalCellImage.layer setBackgroundColor:[UIColor colorWithRed:193.0 / 255.0 green:10.0 / 255.0 blue:22.0 / 255.0 alpha:1.0f].CGColor];
    [cell.goalCellImage.layer setCornerRadius:cell.goalCellImage.frame.size.width/2];
    [cell.goalCellImage.layer setMasksToBounds:YES];
    
    
    return cell;
}

# pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fetch yourText for this row from your data source..
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:_addGoalsArray[indexPath.row][@"GoalText"]
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20.0f]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){300, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return (float)rect.size.height + 20.0;
}

#pragma mark -  User defined methods

- (void)doneWithColorSelection {
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CLNewGoalViewController delegate methods

- (void)addNewgoalWithText:(NSString *)goalText {
    
    NSLog(@"New goal text = %@", goalText);
    
    NSDictionary *moodDict = [[NSDictionary alloc] initWithObjectsAndKeys:goalText,@"GoalText",@"Pending",@"GoalStatus", nil];
    
    if (self.goalFlag) {
        [dataManager saveDictionaryToMoodShotPlist:moodDict];
    } else {
        [dataManager saveDictionaryToReadyTransferPlist:moodDict];
    }
    
    
}

#pragma mark - Navigation

- (void)moveToNewGoalScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CLNewGoalViewController *newgoalViewController = (CLNewGoalViewController *)[storyboard instantiateViewControllerWithIdentifier:@"CLNewGoalScreen"];
    
    if (self.goalFlag) {
        newgoalViewController.titleString = @"New Goal";
    } else {
        newgoalViewController.titleString = @"New Transfer";
    }
    newgoalViewController.delegate = self;
    [self.navigationController pushViewController:newgoalViewController animated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.destinationViewController isKindOfClass:[CLNewGoalViewController class]]) {
        CLNewGoalViewController *newgoalViewController = (CLNewGoalViewController *)segue.destinationViewController;
        newgoalViewController.delegate = self;
    }
}


@end

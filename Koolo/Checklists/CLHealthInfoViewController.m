//
//  CLHealthInfoViewController.m
//  Koolo
//
//  Created by Hamsini on 21/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "CLHealthInfoViewController.h"

@interface CLHealthInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *ongoingLabel;

@end

@implementation CLHealthInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Information";
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    [_finishedLabel.layer setBorderWidth:2.0f];
    [_finishedLabel.layer setMasksToBounds:YES];
    [_finishedLabel.layer setCornerRadius:25.0f];
    [_finishedLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [_pendingLabel.layer setBorderWidth:2.0f];
    [_pendingLabel.layer setMasksToBounds:YES];
    [_pendingLabel.layer setCornerRadius:25.0f];
    [_pendingLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [_ongoingLabel setTextAlignment:NSTextAlignmentCenter];
    [_ongoingLabel.layer setBorderWidth:2.0f];
    [_ongoingLabel.layer setMasksToBounds:YES];
    [_ongoingLabel.layer setCornerRadius:25.0f];
    [_ongoingLabel.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Finished" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithColorSelection)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  User defined methods

- (void)doneWithColorSelection {
    
    
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

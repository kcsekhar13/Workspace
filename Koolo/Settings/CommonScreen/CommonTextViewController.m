//
//  CommonTextViewController.m
//  Koolo
//
//  Created by Hamsini on 25/02/16.
//  Copyright © 2016 Vinodram. All rights reserved.
//

#import "CommonTextViewController.h"

@interface CommonTextViewController ()
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;

@end

@implementation CommonTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.infoArray[0];
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    NSString *infoString = [[NSString alloc] init];
    NSString *doneButtonTitle = @"";
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
    } else {
        doneButtonTitle = @"Done";
    }
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    NSDictionary* barButtonItemAttributes =
    @{NSFontAttributeName:
          [UIFont fontWithName:@"Klavika-Regular" size:20.0f],
      NSForegroundColorAttributeName:
          [UIColor blackColor]
      };
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToSettingsScreen)];
    [doneButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (self.licenseFlag) {
        for (int i = 1; i < self.infoArray.count; i++) {
            
            if (i == 1) {
                infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n", self.infoArray[i]]];
            } else {
                infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"%@ \n", self.infoArray[i]]];
            }
            
        }
    } else {
        for (int i = 1; i < self.infoArray.count; i++) {
            infoString = [infoString stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n", self.infoArray[i]]];
        }
    }
    
    
    
    self.informationTextView.text = infoString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveToSettingsScreen {
    
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

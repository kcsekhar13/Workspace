//
//  TutorialViewController.m
//  Koolo
//
//  Created by Hamsini on 27/02/16.
//  Copyright © 2016 Vinodram. All rights reserved.
//

#import "TutorialViewController.h"
#import "PageItemController.h"


@interface TutorialViewController ()<UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *contentImages;
@property (nonatomic, strong) NSArray *contentDesCription;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation TutorialViewController

#pragma mark -
#pragma mark View Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = self.titleString;
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    NSString *doneButtonTitle = @"";
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
    } else {
        doneButtonTitle = @"Done";
    }
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(moveToSettingsScreen)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    [self createPageViewController];
    [self setupPageControl];
}

- (void) createPageViewController
{
    [[NSBundle mainBundle] pathForResource:@"" ofType:@"jpg"];
    
    _contentImages = @[[[NSBundle mainBundle] pathForResource:@"HomeScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"HomeScreenWithFunctionOptions" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"SettingsScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"CheckListScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"MyhealthScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"NewGoalScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"ReadyForTransitionScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"ThreeSenteceScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"CalendarScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"NewEventScreen" ofType:@"jpg"],
                       [[NSBundle mainBundle] pathForResource:@"EventColorPickerScreen" ofType:@"jpg"]];
    
    _contentDesCription = @[@"HomeScreen",
                            @"HomeScreenWithFunctionOptions",
                            @"SettingsScreen",
                            @"CheckListScreen",
                            @"MyhealthScreen",
                            @"NewGoalScreen",
                            @"ReadyForTransitionScreen",
                            @"ThreeSenteceScreen",
                            @"CalendarScreen",
                            @"NewEventScreen",
                            @"EventColorPickerScreen"];
    
    
    
    UIPageViewController *pageController = [self.storyboard instantiateViewControllerWithIdentifier: @"PageController"];
    pageController.dataSource = self;
    
    if([_contentImages count])
    {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: 0]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController: self.pageViewController];
    [self.view addSubview: self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController: self];
}

- (void) setupPageControl
{
    [[UIPageControl appearance] setPageIndicatorTintColor: [UIColor grayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor: [UIColor whiteColor]];
    [[UIPageControl appearance] setBackgroundColor: [UIColor darkGrayColor]];
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex > 0)
    {
        return [self itemControllerForIndex: itemController.itemIndex-1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController
{
    PageItemController *itemController = (PageItemController *) viewController;
    
    if (itemController.itemIndex+1 < [_contentImages count])
    {
        return [self itemControllerForIndex: itemController.itemIndex+1];
    }
    
    return nil;
}

- (PageItemController *) itemControllerForIndex: (NSUInteger) itemIndex
{
    if (itemIndex < [_contentImages count])
    {
        PageItemController *pageItemController = [self.storyboard instantiateViewControllerWithIdentifier: @"ItemController"];
        pageItemController.itemIndex = itemIndex;
        pageItemController.imageName = _contentImages[itemIndex];
        pageItemController.description = _contentDesCription[itemIndex];
        return pageItemController;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Page Indicator

- (NSInteger) presentationCountForPageViewController: (UIPageViewController *) pageViewController
{
    return [_contentImages count];
}

- (NSInteger) presentationIndexForPageViewController: (UIPageViewController *) pageViewController
{
    return 0;
}

#pragma mark - User defined methods

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

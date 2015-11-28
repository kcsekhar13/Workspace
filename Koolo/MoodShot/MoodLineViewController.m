//
//  MoodLineViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MoodLineViewController.h"
#import "MSPreViewViewController.h"
#import "ViewController.h"
#import "MoodMapViewController.h"

@interface MoodLineViewController () <MoodMapDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoodLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToHomeScreen)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    [self.moodLineTableView addGestureRecognizer:swipeRight];
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *filterTitle = nil;
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"]) {
        filterTitle = NSLocalizedString(@"Map", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        self.title = NSLocalizedString(@"Mood Line", nil);
        
    } else {
        filterTitle = @"Map";
        doneButtonTitle = @"Done";
         self.title = @"Mood Line";
    }
    
    pinchFlag = YES;
    dataManager = [StoreDataMangager sharedInstance];
    UIImage *backgroundImage = dataManager.returnBackgroundImage;
    if (backgroundImage) {
        _backgroundImageView.image = backgroundImage;
    }
    
    // create blur effect
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    // create vibrancy effect
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    // add blur to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add vibrancy to yet another effect view
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    vibrantView.frame = self.view.frame;
    effectView.alpha = 0.9;
    vibrantView.alpha = 0.9;
    // add both effect views to the image view
    [self.backgroundImageView addSubview:effectView];
    [self.backgroundImageView addSubview:vibrantView];
    
    // Do any additional setup after loading the view.
    
    [dataManager checkDummyMoods];
    self.moodsArray = (NSMutableArray *)[dataManager getMoodsFromPlist];
    self.moodLineTableView.backgroundView = nil;
    self.moodLineTableView.backgroundColor = [UIColor clearColor];
    self.moodLineTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(backToHomeScreen)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* filterButton = [[UIBarButtonItem alloc] initWithTitle:filterTitle style:UIBarButtonItemStylePlain target:self action:@selector(handlePinchWithGestureRecognizer)];
    [filterButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = filterButton;
    
//    pinchGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchWithGestureRecognizer)];
//    pinchGestureRecognizer.numberOfTapsRequired = 2;                                                                  
//    [self.view addGestureRecognizer:pinchGestureRecognizer];
//    [self.moodLineTableView addGestureRecognizer:pinchGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = NO;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource and Delegate methods

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

    if ([dict objectForKey:@"ColorIndex"]) {
        tableViewCell.moodColorImage.backgroundColor = dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]];
        tableViewCell.moodCellImage.image = [UIImage imageWithContentsOfFile:savedImagePath];
        [tableViewCell setBoarderColor:dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]]];
        [tableViewCell.moodCellImage.layer setBorderColor:((UIColor*)(dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]])).CGColor];
        [tableViewCell.dateLabel setText:[dataManager getDateStringFromDate:[dict  objectForKey:@"FileName"]]];
        [tableViewCell.dateLabel setBackgroundColor:((UIColor*)(dataManager.fetchColorsArray[[[dict  objectForKey:@"ColorIndex"] intValue]]))];
        [tableViewCell.dateLabel setTextColor:[UIColor whiteColor]];


    }
    else{
        tableViewCell.moodColorImage.backgroundColor = [UIColor lightGrayColor];
        tableViewCell.moodCellImage.image = nil;
        tableViewCell.moodCellImage.backgroundColor = [UIColor lightGrayColor];
        [tableViewCell setBoarderColor:[UIColor whiteColor]];
        [tableViewCell.moodCellImage.layer setBorderColor:[UIColor whiteColor].CGColor];
        [tableViewCell.dateLabel setText:[dataManager getDateStringFromDate:[dict  objectForKey:@"FileName"]]];
        [tableViewCell.dateLabel setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell.dateLabel setTextColor:[UIColor lightGrayColor]];
        
        
    }
    [tableViewCell.moodColorImage.layer setBorderColor:[UIColor clearColor].CGColor];
    [tableViewCell.moodColorImage.layer setCornerRadius:tableViewCell.moodColorImage.frame.size.width/2];
    [tableViewCell.moodColorImage.layer setMasksToBounds:YES];

    [tableViewCell.moodCellImage.layer setMasksToBounds:YES];
    [tableViewCell.moodCellImage.layer setBorderWidth:10.0];
    [tableViewCell drawBoarderForCell];
    
    return tableViewCell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 251.0;
}

#pragma mark -  UIImagePickerController Delegate methods

// Uncomment this code if your checking app in simulator

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo {
    
    
    NSData *imageData = UIImagePNGRepresentation(image);
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self moveToPreviewScreen:imageData];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    /*
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
     NSData *imageData = UIImagePNGRepresentation(image);
     [imageData writeToFile:savedImagePath atomically:YES];*/
    UIImage *image = (UIImage*) [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(image);
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self moveToPreviewScreen:imageData];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
}

- (void)moveToPreviewScreen:(NSData*)selectedImage {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MSPreViewViewController *obj  = [storyboard instantiateViewControllerWithIdentifier:@"MSPreviewScreen"];
    [obj setSelectedImageData:selectedImage];
    [self.navigationController pushViewController:obj animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)launchCamera:(id)sender {
    
    self.activityIndicator.center = CGPointMake(self.view.center.x, (self.view.center.y/2)+100) ;
    [self.activityIndicator startAnimating];

    dispatch_async(dispatch_queue_create("openPhotosCamera", NULL), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //hide HUD or activityIndicator
            _imagePickerController  = [[UIImagePickerController alloc]init];
            _imagePickerController.delegate = self;
            //Change source type to Photo library while checking app in simulator
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
            [self.activityIndicator stopAnimating];
        });
    });
}
- (IBAction)launchAlbum:(id)sender {
    self.activityIndicator.center = CGPointMake(self.view.center.x, (self.view.center.y/2)+100) ;
    [self.activityIndicator startAnimating];
    dispatch_async(dispatch_queue_create("openPhotosCamera", NULL), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //hide HUD or activityIndicator
            _imagePickerController  = [[UIImagePickerController alloc]init];
            _imagePickerController.delegate = self;
            //Change source type to Photo library while checking app in simulator
            _imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:_imagePickerController animated:YES completion:nil];
            [self.activityIndicator stopAnimating];
        });
    });
}

- (void)backToHomeScreen {
    
    for (UIViewController *homeViewController in [self.navigationController viewControllers]) {
        if ([homeViewController isKindOfClass:[ViewController class]]) {
            [self.navigationController popToViewController:homeViewController animated:YES];
        }
    }
}

#pragma mark - MoodMapDelegate methods 

- (void)filterMoodPics:(NSInteger)tag {
    
    if ([self.moodsArray count]) {
        [self.moodsArray removeAllObjects];
    }
    self.moodsArray = (NSMutableArray *)[dataManager getMoodsFromPlist];
   
    if (tag != -1) {
        
        NSMutableArray *filterArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < self.moodsArray.count; i++) {
            
            NSDictionary *dict = (NSDictionary *)self.moodsArray[i];
            NSInteger selectedColorTag = [dict[@"ColorIndex"] integerValue];
            
            if (selectedColorTag == tag) {
                [filterArray addObject:dict];
            }
        }
        self.moodsArray = filterArray;

    }
    
    [self.moodLineTableView reloadData];
}

#pragma mark - UIPinchGestureRecognizer methods

-(void)handlePinchWithGestureRecognizer{
    
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        MoodMapViewController *moodMapviewConroller = (MoodMapViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MoodMapScreen"];
        moodMapviewConroller.delegate = self;
        [self.navigationController pushViewController:moodMapviewConroller animated:YES];
        
   
}
@end

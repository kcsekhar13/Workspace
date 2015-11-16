//
//  SettingScreenViewController.m
//  Koolo
//
//  Created by Vinodram on 08/10/15.
//  Copyright (c) 2015 Vinodram. All rights reserved.
//

#import "SettingScreenViewController.h"
#import "QuotesViewController.h"
#import "PasscodeHomeViewController.h"


@interface SettingScreenViewController ()  {
    NSArray *contentArray;
    
}
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SettingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"]) {
        
        self.title = NSLocalizedString(@"Settings", nil);
        contentArray = [[NSArray alloc] initWithObjects:@"Bakgrunnsbilde", @"Passkode", @"Sitater", @"Lisens",@"Fargevalg", @"", @"", nil];
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        doneButtonTitle = NSLocalizedString(@"Ready", nil);
        
    } else {
        self.title = @"Settings";
        contentArray = [[NSArray alloc] initWithObjects:@"BackgroundImage", @"Passcode", @"Quotes", @"License",@"Humor Colors", @"", @"", nil];
        cancelTitle = @"Cancel";
        doneButtonTitle = @"Finished";
    }
    NSLog(@"Language = %@", language);
    
    self.navigationController.navigationBar.hidden = NO;
    
    _imagePickerController  = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [leftButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [rightButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSError *error = nil;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: stringPath  error:&error];
    
    if (filePathsArray.count != 0) {
        NSString *strFilePath = [filePathsArray objectAtIndex:0];
        if ([[strFilePath pathExtension] isEqualToString:@"jpg"] || [[strFilePath pathExtension] isEqualToString:@"png"] || [[strFilePath pathExtension] isEqualToString:@"PNG"])
        {
            NSString *imagePath = [[stringPath stringByAppendingString:@"/"] stringByAppendingString:strFilePath];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            if(data)
            {
                UIImage *image = [UIImage imageWithData:data];
                _backgroundImageView.image = image;
            }
        }
    }
    [super viewWillAppear:animated];
    
}

#pragma mark -  UITableView dataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = contentArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (indexPath.row == 1) {
        
        /*
        UISwitch *onSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-40, 10, 40, 40)];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"isPassCodeOn"]) {
            
            [onSwitch setOn:YES animated:YES];

        }
        else{
            
            [onSwitch setOn:NO animated:YES];

        }
        [onSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:onSwitch];*/
        
    }
    
    return cell;
}

-(void)changeSwitch:(UISwitch*)passSwitch
{
    
    [[NSUserDefaults standardUserDefaults] setBool:passSwitch.isOn forKey:@"isPassCodeOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
#pragma mark -  UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    if (indexPath.row == 0) {
        
        dispatch_async(dispatch_queue_create("openPhotosCamera", NULL), ^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //hide HUD or activityIndicator
               
                [self presentViewController:_imagePickerController animated:YES completion:nil];
            });
        });
        
        
    } else if (indexPath.row == 2) {
        
        
        QuotesViewController *quotesViewController = (QuotesViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"QuotesController"];
        [self.navigationController pushViewController:quotesViewController animated:YES];
        
    } else if (indexPath.row == 1) {
        
        
        PasscodeHomeViewController *passcodeHomeScreen = (PasscodeHomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"PasscodeHome"];
        
        [self.navigationController pushViewController:passcodeHomeScreen animated:YES];
        /*
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        PassCodeViewController *passCodeViewController = (PassCodeViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"PasscodeController"];
        [passCodeViewController setMode:1];
        [self.navigationController pushViewController:passCodeViewController animated:YES];
         */
        
    } else if (indexPath.row == 4) {
        
        [self.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier: @"MSColorPickerScreen"] animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -  UIImagePickerController Delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo {
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePathAndDirectory = [documentsDirectory stringByAppendingPathComponent:@"BackgroundImages"];
    NSError *error;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
       // NSLog(@"Create directory error: %@", error);
    }

    NSString *savedImagePath = [filePathAndDirectory stringByAppendingPathComponent:@"savedImage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:YES];
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - User defined mehtods
- (void)cancelScreen {
    self.navigationController.navigationBar.hidden = YES;
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

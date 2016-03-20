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
#import "CommonTextViewController.h"
#import "TutorialViewController.h"


@interface SettingScreenViewController ()  {
    NSArray *contentArray;
    
}
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SettingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *cancelTitle = nil;
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
        
        self.title = NSLocalizedString(@"Settings", nil);
        contentArray = [[NSArray alloc] initWithObjects:@"Bakgrunnsbilde", @"Passkode", @"Sitater", @"Lisens",@"Fargevalg", @"Gjennnomgang av applikasjonen", @"Oppdateringer", @"Bidrag",@"Om appen",nil];
        cancelTitle = NSLocalizedString(@"Cancel", nil);
        doneButtonTitle = NSLocalizedString(@"Done", nil);
        
    } else {
        self.title = @"Settings";
        contentArray = [[NSArray alloc] initWithObjects:@"Background Image", @"Passcode", @"Quotes", @"License",@"Humor Colors", @"Tutorial", @"Updates", @"Contributors", @"About",nil];
        cancelTitle = @"Cancel";
        doneButtonTitle = @"Done";
    }
    
       
    
    self.navigationController.navigationBar.hidden = NO;
    
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
    _imagePickerController  = [[UIImagePickerController alloc]init];
    _imagePickerController.delegate = self;
    _imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    NSDictionary* barButtonItemAttributes =
    @{NSFontAttributeName:
          [UIFont fontWithName:@"Klavika-Regular" size:20.0f],
      NSForegroundColorAttributeName:
          [UIColor blackColor]
      };
    
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [leftButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancelScreen)];
    [rightButton setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
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
    cell.textLabel.font = [UIFont fontWithName:@"Klavika-Medium" size:15.0f];
    
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
        
        self.activityIndicator.center = CGPointMake(self.view.center.x, (self.view.center.y/2)+100) ;
        [self.activityIndicator startAnimating];
        
        dispatch_async(dispatch_queue_create("openPhotosCamera", NULL), ^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //hide HUD or activityIndicator
               
                [self presentViewController:_imagePickerController animated:YES completion:nil];
                [self.activityIndicator stopAnimating];
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
    }  else if (indexPath.row == 3 || indexPath.row == 7 || indexPath.row == 8) {
        
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSString *typeString = nil;
        if ([language isEqualToString:@"nb"] || [language isEqualToString:@"nb-US"]|| [language isEqualToString:@"nb-NO"]) {
            typeString = @"_Nor.plist";
        } else {
            typeString = @"_Eng.plist";
        }
        
        if (indexPath.row == 3) {
            
            NSString *fileString = [NSString stringWithFormat:@"License%@", typeString];
            [self moveToTextViewScreenWithFileName:fileString withFlag:YES];
            
        } else if (indexPath.row == 7) {
            
            NSString *fileString = [NSString stringWithFormat:@"Contributions%@", typeString];
            [self moveToTextViewScreenWithFileName:fileString withFlag:NO];
            
        } else {
            
            NSString *fileString = [NSString stringWithFormat:@"About%@", typeString];
            [self moveToTextViewScreenWithFileName:fileString withFlag:NO];
        }
    } else if (indexPath.row == 5) {
        TutorialViewController *tutorialViewController = (TutorialViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"Tutorial"];
        tutorialViewController.titleString = contentArray[indexPath.row];
        
        [self.navigationController pushViewController:tutorialViewController animated:YES];
        
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
    NSData *imageData = UIImagePNGRepresentation([self scaleAndRotateImage:image]);
    [imageData writeToFile:savedImagePath atomically:YES];
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    //return imageCopy;
}


#pragma mark - User defined mehtods
- (void)cancelScreen {
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moveToTextViewScreenWithFileName:(NSString *)fileName withFlag:(BOOL)licenseflag {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    CommonTextViewController *infoScreen = (CommonTextViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"CommonScreen"];
    infoScreen.infoArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:nil]];
    infoScreen.licenseFlag = licenseflag;
    [self.navigationController pushViewController:infoScreen animated:YES];
    
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

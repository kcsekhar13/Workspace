//
//  MSCameraViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MSCameraViewController.h"
#import "MSPreViewViewController.h"
@interface MSCameraViewController ()

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@end

@implementation MSCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Mood Shot";
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"enableCamera"]) {
        dispatch_async(dispatch_queue_create("openPhotosCamera", NULL), ^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //hide HUD or activityIndicator
                _imagePickerController  = [[UIImagePickerController alloc]init];
                _imagePickerController.delegate = self;
                //Change source type to Photo library while checking app in simulator
                _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"enableCamera"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self presentViewController:_imagePickerController animated:YES completion:nil];
            });
        });
    }
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  UIImagePickerController Delegate methods

// Uncomment this code if your checking app in simulator
/*
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo {
    
 
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
//    NSData *imageData = UIImagePNGRepresentation(image);
  //  [imageData writeToFile:savedImagePath atomically:YES];
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self moveToPreviewScreen];
    
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    /*
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
     NSData *imageData = UIImagePNGRepresentation(image);
     [imageData writeToFile:savedImagePath atomically:YES];*/
    
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self moveToPreviewScreen];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:_imagePickerController completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)moveToPreviewScreen {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MSPreviewScreen"] animated:YES];
}

@end

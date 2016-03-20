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
    NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Klavika-Bold" size:20.0],NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = size;
    
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
                _imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
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
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)moveToPreviewScreen:(NSData*)selectedImage {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MSPreViewViewController *obj  = [storyboard instantiateViewControllerWithIdentifier:@"MSPreviewScreen"];
    [obj setSelectedImageData:selectedImage];
    [self.navigationController pushViewController:obj animated:YES];
}

@end

//
//  MSPreViewViewController.m
//  Koolo
//
//  Created by Hamsini on 28/10/15.
//  Copyright © 2015 Vinodram. All rights reserved.
//

#import "MSPreViewViewController.h"
#import "MSColorPickerViewController.h"
#import "ColorPickerCollectionViewCell.h"


@interface MSPreViewViewController ()<ColorPickerCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *graphPickerCollectionView;

@end

@implementation MSPreViewViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self.title = @"Select Humor Color";
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *doneButtonTitle = nil;
    if ([language isEqualToString:@"nb"]) {
        doneButtonTitle = NSLocalizedString(@"Return", nil);
        self.title = NSLocalizedString(@"SelectHumorColor", nil);
        
    } else {
        doneButtonTitle = @"Return";
        self.title = @"Select Humor Color";
    }
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(backToMoodLine)];
    [doneButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = doneButton;
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    [self.imageView setImage:[UIImage imageWithData:self.selectedImageData]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    dataManager = [StoreDataMangager sharedInstance];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
    [self.graphPickerCollectionView reloadData];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return dataManager.fetchColorPickerTitlesArray.count;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorPickerCollectionViewCell *cell = (ColorPickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"colorCell" forIndexPath:indexPath];
    
    //cell.colorKeyView.backgroundColor = colorsArray[indexPath.row];
    [cell.pickerButton setTitle:dataManager.fetchColorPickerTitlesArray[indexPath.row] forState:UIControlStateNormal];
    [cell.pickerButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [cell.colorKeyView.layer setBorderColor:[UIColor clearColor].CGColor];
    [cell.colorKeyView.layer setCornerRadius:cell.colorKeyView.frame.size.width/2];
    [cell.colorKeyView.layer setMasksToBounds:YES];
    cell.colorKeyView.backgroundColor = (UIColor *)dataManager.fetchColorsArray[indexPath.row];
    cell.delegate = self;
    cell.selectedColorIndex = indexPath.row;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // Add inset to the collection view if there are not enough cells to fill the width.
    CGFloat cellSpacing = ((UICollectionViewFlowLayout *) collectionViewLayout).minimumLineSpacing;
    CGFloat cellWidth = ((UICollectionViewFlowLayout *) collectionViewLayout).itemSize.width;
    NSInteger cellCount = [collectionView numberOfItemsInSection:section];
    CGFloat inset = (collectionView.bounds.size.width - (cellCount * (cellWidth + cellSpacing))) * 0.5;
    inset = MAX(inset, 0.0);
    return UIEdgeInsetsMake(0.0, (inset - 15.0f / 2)  , 0.0, 0.0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self saveToDB:indexPath];


}

-(void)saveToDB:(NSIndexPath*)indexPath
{
     
    NSString *fileName = [NSString stringWithFormat:@"%@.png",[dataManager getStringFromDate:[NSDate date]]];
     NSString *savedImagePath = [[dataManager getDocumentryPath] stringByAppendingPathComponent:fileName];
    NSLog(@"%d >>>>>",[self.selectedImageData writeToFile:savedImagePath atomically:YES]);
    NSString *moodName = dataManager.fetchColorPickerTitlesArray[indexPath.row];
    NSString *colorIndex = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    NSDictionary *moodDict = [[NSDictionary alloc] initWithObjectsAndKeys:fileName,@"FileName",moodName,@"MoodName",colorIndex,@"ColorIndex",savedImagePath,@"FilePath", nil];
    [dataManager saveDictionaryToPlist:moodDict];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MoodLineScreen"] animated:YES];
    
}

#pragma mark - ColorPickerCollectionViewCell delegate methods

- (void)moveToColorPickerViewController:(id)sender {
    
    ColorPickerCollectionViewCell *colorCell =  (ColorPickerCollectionViewCell *)sender;
    NSLog(@"Selected Cell = %ld", (long)colorCell.selectedColorIndex);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    [self.navigationController pushViewController:[storyboard instantiateViewControllerWithIdentifier:@"MSColorPickerScreen"] animated:YES];
}

- (void)backToMoodLine {
    
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

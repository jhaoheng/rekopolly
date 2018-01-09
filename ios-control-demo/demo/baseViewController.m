//
//  baseViewController.m
//  demo
//
//  Created by max on 2017/12/18.
//  Copyright © 2017年 max. All rights reserved.
//

#import "baseViewController.h"
#import "cameraResultViewController.h"
#import "AwsRekoObject.h"

@interface baseViewController (){
    NSMutableArray *facesArray;
    UITableView *maintable;
    UIActivityIndicatorView *indicatorView;
}

@end

@implementation baseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    facesArray = [[NSMutableArray alloc] init];
    
    
    CGRect tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    maintable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    maintable.delegate = self;
    maintable.dataSource = self;
    maintable.allowsSelection = NO;
    [self.view addSubview:maintable];
    

    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.hidesWhenStopped = YES;
    [indicatorView startAnimating];
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData:) name:rekoListTicket object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    // load list to show
    AwsRekoObject *reko = [AwsRekoObject defaultinstance];
    [reko ListFacesWithCollectionId:@"orbweb"];
    
}

- (void)getData:(NSNotification *)sender {
    NSArray *arr = sender.object;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"externalImageId" ascending:YES];
    arr = [arr sortedArrayUsingDescriptors:@[sort]];
    facesArray = [[NSMutableArray alloc] initWithArray:arr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [maintable reloadData];
        [indicatorView stopAnimating];
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if(navigationController.viewControllers.count != 1) { // not the root controller - show back button instead
        return;
    }
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(takepic:)];
    [viewController.navigationItem setRightBarButtonItem:menuItem];
}

#pragma mark - take pic
- (void)takepic:(id)sender{

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    // 判斷是否可開啟相機
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        // 開啟圖庫
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    NSLog(@"%@",mediaType);
    if ([mediaType isEqualToString:@"public.image"]) {
        // 得到照片
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imgdata = UIImageJPEGRepresentation(self.image, 0.9);
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // 存入相册
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            [self jumpToResultWithImg];
        }];
    }
    else{
        
        [self dismissViewControllerAnimated:NO completion:^(void){
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpToResultWithImg{
    //跳入結果頁面
    cameraResultViewController *camera = [[cameraResultViewController alloc] init];
    camera.image = self.image;
    camera.imagedata = self.imgdata;
    camera.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [UIView transitionWithView:self.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController pushViewController:camera animated:NO];
                    }
                    completion:nil];
}

#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return facesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELL_ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [[facesArray objectAtIndex:indexPath.row] objectForKey:@"externalImageId"];
    cell.detailTextLabel.text = [[facesArray objectAtIndex:indexPath.row] objectForKey:@"faceId"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        NSString *faceId = [[facesArray objectAtIndex:indexPath.row] objectForKey:@"faceId"];
        AwsRekoObject *reko = [AwsRekoObject defaultinstance];
        [reko DeleteFacesWithCollectionId:@"orbweb" FaceIds:@[faceId]];
        
        [facesArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

@end

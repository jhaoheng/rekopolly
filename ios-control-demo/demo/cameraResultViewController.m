//
//  cameraResultViewController.m
//  demo
//
//  Created by max on 2017/12/18.
//  Copyright © 2017年 max. All rights reserved.
//

#import "cameraResultViewController.h"
#import "AwsRekoObject.h"

@interface cameraResultViewController (){
    UITextField *inputField;
    UIActivityIndicatorView *indicatorView;
    UIView *maskView;
}

@end

@implementation cameraResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    float inputFieldWidth = self.view.frame.size.width - 20;
    float inputFieldOrginHeight = self.navigationController.navigationBar.frame.size.height+40;
    CGRect inputFieldFrame = CGRectMake((self.view.frame.size.width-inputFieldWidth)/2, inputFieldOrginHeight, inputFieldWidth, 44);
    
    inputField = [[UITextField alloc] initWithFrame:inputFieldFrame];
    inputField.placeholder = @"user name, don't any blank";
    inputField.borderStyle = UITextBorderStyleLine;
    inputField.textColor = [UIColor blackColor];
    inputField.delegate = self;
    [self.view addSubview:inputField];
    
    
    float scale = (self.view.frame.size.width-20)/self.image.size.width;
    float wsize = self.image.size.width*scale;
    float hsize = self.image.size.height*scale;
    CGRect imgviewFrame = CGRectMake((self.view.frame.size.width-wsize)/2, CGRectGetMaxY(inputField.frame) +20 , wsize, hsize);
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:imgviewFrame];
    imgview.image = self.image;
    [self.view addSubview:imgview];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(rekoIndex)];
    [self.navigationItem setRightBarButtonItem:menuItem];
    
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.hidesWhenStopped = YES;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
    // maskView
    maskView = [[UIView alloc] initWithFrame:self.navigationController.view.frame];
    maskView.alpha = 0;
    maskView.backgroundColor = [UIColor grayColor];
    [self.navigationController.view addSubview:maskView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationGetSuccess:) name:rekoIndexTicket object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationGetError:) name:errorTicket object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                    completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)rekoIndex{
    [self textFieldShouldReturn:inputField];
    
    NSString *text = inputField.text;
    if (text.length == 0) {
        return;
    }
    else{
        NSArray *textItems = [inputField.text componentsSeparatedByString:@" "];
        text = textItems[0];
    }
    NSLog(@"text : %@",text);
    AwsRekoObject *reko = [AwsRekoObject defaultinstance];
    [reko IndexFacesWithCollectionId:@"orbweb" ExternalImageId:text Image:self.imagedata];
    
    maskView.alpha = .5;
    [indicatorView startAnimating];
}

#pragma mark - field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;  // Hide both keyboard and blinking cursor.
}

#pragma mark - hidden view
- (void)notificationGetSuccess:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicatorView stopAnimating];
        maskView.alpha=0;
        [self.navigationController popToRootViewControllerAnimated: YES];
    });
}

- (void)notificationGetError:(NSNotification *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [indicatorView stopAnimating];
        maskView.alpha=0;
        [self.navigationController popToRootViewControllerAnimated: YES];
    });
}

@end

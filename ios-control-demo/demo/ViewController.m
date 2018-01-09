//
//  ViewController.m
//  demo
//
//  Created by max on 2017/12/9.
//  Copyright © 2017年 max. All rights reserved.
//



#import "ViewController.h"
#import "AwsRekoObject.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(show:) name:rekoListTicket object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test {
    
    AwsRekoObject *reko = [AwsRekoObject defaultinstance];
    [reko ListFacesWithCollectionId:@"orbweb"];
}

- (void)show:(NSNotification *)sender {
    NSMutableArray *array = sender.object;
    NSLog(@"%@", array);
}

#pragma mark - take picture
- (void)takepic:(id)sender{
    NSLog(@"take pic");
    
    
//    infoViewController *infoView = [[infoViewController alloc] init];
//    infoView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    //    [self presentViewController:infoView animated:YES completion:nil];
//    [UIView transitionWithView:self.view
//                      duration:0.75
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    animations:^{
//                        [self pushViewController:infoView animated:NO];
//                    }
//                    completion:nil];
//    //    [self pushViewController:infoView animated:YES];
}

@end

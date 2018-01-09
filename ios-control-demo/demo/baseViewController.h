//
//  baseViewController.h
//  demo
//
//  Created by max on 2017/12/18.
//  Copyright © 2017年 max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSData *imgdata;

@end

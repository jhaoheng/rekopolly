//
//  AwsRekoObject.h
//  demo
//
//  Created by max on 2017/12/18.
//  Copyright © 2017年 max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSRekognition.h>

@interface AwsRekoObject : NSObject

@property (nonatomic, strong) NSString * _Nullable accessKey;
@property (nonatomic, strong) NSString * _Nullable secretKey;

+ (AwsRekoObject * _Nonnull)defaultinstance;


extern NSString * _Nonnull rekoIndexTicket;
- (void)IndexFacesWithCollectionId:(NSString * _Nonnull)CollectionId ExternalImageId:(NSString * _Nonnull)ExternalImageId Image:(NSData * _Nonnull)Image;

extern NSString * _Nonnull rekoListTicket;
- (void)ListFacesWithCollectionId:(NSString * _Nonnull)CollectionId;

extern NSString * _Nonnull rekoDelTicket;
- (void)DeleteFacesWithCollectionId:(NSString * _Nonnull)CollectionId FaceIds:(NSArray * _Nonnull)FaceIds;

extern NSString * _Nonnull errorTicket;

@end

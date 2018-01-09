//
//  AwsRekoObject.m
//  demo
//
//  Created by max on 2017/12/18.
//  Copyright © 2017年 max. All rights reserved.
//

#import "AwsRekoObject.h"

@implementation AwsRekoObject

NSString * rekoListTicket = @"reko list image";
NSString * rekoIndexTicket = @"reko Index image";
NSString * rekoDelTicket = @"reko Del image";
NSString * errorTicket = @"error";


AwsRekoObject *reko;
+ (AwsRekoObject *)defaultinstance{
    if (reko==nil) {
        reko = [[self alloc] init];
        reko.accessKey = @"AKIAIZASL2REQLTONNOA";
        reko.secretKey = @"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";
        
        AWSStaticCredentialsProvider *credential = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:reko.accessKey secretKey:reko.secretKey];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSWest2 credentialsProvider:credential];
        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    }
    return reko;
}

#pragma mark - index faces
- (void)IndexFacesWithCollectionId:(NSString *)CollectionId ExternalImageId:(NSString *)ExternalImageId Image:(NSData *)Image{
    
    AWSRekognitionImage *rekoimg = [[AWSRekognitionImage alloc] init];
    rekoimg.bytes = Image;
    
    AWSRekognition *Rekognition = [AWSRekognition defaultRekognition];
    AWSRekognitionIndexFacesRequest *request = [[AWSRekognitionIndexFacesRequest alloc] init];
    request.collectionId = CollectionId;
    request.externalImageId = ExternalImageId;
    request.image = rekoimg;
    
    [Rekognition indexFaces:request completionHandler:^(AWSRekognitionIndexFacesResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:errorTicket object:error];
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:rekoIndexTicket object:response];
    }];
}

#pragma mark - list faces
- (void)ListFacesWithCollectionId:(NSString *)CollectionId {
    
    AWSRekognition *Rekognition = [AWSRekognition defaultRekognition];
    AWSRekognitionListFacesRequest *request = [[AWSRekognitionListFacesRequest alloc] init];
    request.collectionId = CollectionId;
    
    [Rekognition listFaces:request completionHandler:^(AWSRekognitionListFacesResponse * _Nullable response, NSError * _Nullable error){
        
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:errorTicket object:error];
        }
        else{
            NSMutableArray *datas = [[NSMutableArray alloc] init];
            for (int i=0; i<[response.faces count]; i++) {
                NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                [data setObject:response.faces[i].externalImageId forKey:@"externalImageId"];
                [data setObject:response.faces[i].faceId forKey:@"faceId"];
                [datas addObject:data];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:rekoListTicket object:datas];
        }
    }];
}

#pragma mark - del face
- (void)DeleteFacesWithCollectionId:(NSString *)CollectionId FaceIds:(NSArray *)FaceIds{
    AWSRekognition *Rekognition = [AWSRekognition defaultRekognition];
    AWSRekognitionDeleteFacesRequest *request = [[AWSRekognitionDeleteFacesRequest alloc] init];
    request.collectionId = CollectionId;
    request.faceIds = FaceIds;
    
    [Rekognition deleteFaces:request completionHandler:^(AWSRekognitionDeleteFacesResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:errorTicket object:error];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:rekoDelTicket object:response];
        }
    }];
    
}
@end

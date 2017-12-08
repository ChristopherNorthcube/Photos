//
//  ViewController.m
//  Photos
//
//  Created by Christopher Eliasson on 2017-12-08.
//  Copyright © 2017 Christopher. All rights reserved.
//

#import "ViewController.h"

#import <Photos/Photos.h>
#import <PureLayout.h>


@interface ViewController ()
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.backgroundColor = UIColor.redColor;
    [self.view addSubview: self.imageView];
    
    [self.imageView autoSetDimensionsToSize:CGSizeMake(400, 400)];
    [self.imageView autoCenterInSuperview];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self load];
}

- (void)load {
    self.imageManager = [[PHImageManager alloc] init];
    PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    NSPredicate *predicateMediaType = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    NSDate *startDate = [[NSDate alloc] initWithTimeIntervalSince1970:1512725580]; // 10:33 lokal tid
    NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSince1970:1512726600]; // 10:50 lokal tid
    
    NSPredicate *predicateDate = [NSPredicate predicateWithFormat:@"creationDate >= %@ && creationDate < %@", startDate, endDate];
    
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateDate, predicateMediaType]];
    allPhotosOptions.predicate = compoundPredicate;
    NSMutableArray *images = [NSMutableArray array];
    
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    self.requestOptions.synchronous = YES;
    
    PHFetchResult *allPhotosResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
    
    for(PHAsset *asset in allPhotosResult) {
        [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:self.requestOptions resultHandler:^(UIImage *image, NSDictionary *info) {
            [images addObject:image];
        }];
    }
    
    
    
    self.imageView.image = images.firstObject;
}


@end

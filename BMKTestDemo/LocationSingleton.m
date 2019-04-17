//
//  LocationSingleton.m
//  BMKTestDemo
//
//  Created by john.jiang on 2019/4/17.
//  Copyright © 2019 john.jiang. All rights reserved.
//

#import "LocationSingleton.h"

static LocationSingleton *_locationSingleton = nil;

@interface LocationSingleton () <BMKLocationManagerDelegate>

@property (strong, nonatomic) BMKLocationManager *manager;

@end

@implementation LocationSingleton

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationSingleton = [[LocationSingleton alloc] init];
    });
    return _locationSingleton;
}

- (instancetype)init {
    if (self = [super init]) {
        _manager = [[BMKLocationManager alloc] init];
//        _manager.delegate = self;
    }
    return self;
}

- (void)locationOnceWithComletionBlock:(void (^)(BMKLocation * _Nonnull, NSError * _Nonnull))completionBlock {
    [self.manager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        completionBlock(location, error);
    }];
}

@end

//
//  LocationSingleton.h
//  BMKTestDemo
//
//  Created by john.jiang on 2019/4/17.
//  Copyright © 2019 john.jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationSingleton : NSObject

+ (instancetype)sharedInstance;

- (void)locationOnceWithComletionBlock:(void(^)(BMKLocation * _Nullable location, NSError * _Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END

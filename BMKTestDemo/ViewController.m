//
//  ViewController.m
//  BMKTestDemo
//
//  Created by john.jiang on 2019/4/16.
//  Copyright © 2019 john.jiang. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSuggestionSearch.h>

@interface ViewController () <BMKSuggestionSearchDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)searchAction:(id)sender {
    BMKSuggestionSearch *search = [[BMKSuggestionSearch alloc] init];
    search.delegate = self;
    BMKSuggestionSearchOption *option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"上海";
    option.keyword  = @"迪士尼";
    BOOL flag = [search suggestionSearch:option];
    if (flag) {
        NSLog(@"Sug检索发送成功");
    }  else  {
        NSLog(@"Sug检索发送失败");
    }
}

#pragma mark - BMKSuggestionSearchDelegate
/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:( BMKSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        for (BMKSuggestionInfo *info in result.suggestionList) {
            NSLog(@"\n%@\n%@\n%@", info.key, info.city, info.district);
        }
    }
    else {
        NSLog(@"检索失败");
    }
}

@end

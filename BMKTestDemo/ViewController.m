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

static NSString * const resultCellIdentifier = @"ResultCellIdentifier";

@interface ViewController () <BMKSuggestionSearchDelegate, UISearchBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) BMKSuggestionSearch *search;
@property (strong, nonatomic) BMKSuggestionSearchOption *option;
@property (strong, nonatomic) BMKSuggestionSearchResult *result;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.result = nil;
        return;
    }
    self.option.keyword = searchText;
    self.search.delegate = self;
    BOOL flag = [self.search suggestionSearch:self.option];
    if (flag) {
        NSLog(@"Sug检索发送成功");
    }  else  {
        NSLog(@"Sug检索发送失败");
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.suggestionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resultCellIdentifier forIndexPath:indexPath];
    BMKSuggestionInfo *info = self.result.suggestionList[indexPath.row];
    cell.textLabel.text = info.key;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@", info.city, info.district];
    return cell;
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
        self.result = result;
        for (BMKSuggestionInfo *info in result.suggestionList) {
            NSLog(@"\n%@\n%@\n%@", info.key, info.city, info.district);
        }
    }
    else {
        NSLog(@"检索失败");
    }
    searcher.delegate = nil;
}

#pragma mark - Properties

- (BMKSuggestionSearch *)search {
    if (_search == nil) {
        _search = [[BMKSuggestionSearch alloc] init];
    }
    return _search;
}

- (BMKSuggestionSearchOption *)option {
    if (_option == nil) {
        _option = [[BMKSuggestionSearchOption alloc] init];
        _option.cityname = @"上海";
    }
    return _option;
}

- (void)setResult:(BMKSuggestionSearchResult *)result {
    _result = result;
    [self.tableView reloadData];
}

@end

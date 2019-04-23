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
#import "LocationSingleton.h"
#import <pthread.h>

static NSString * const resultCellIdentifier = @"ResultCellIdentifier";

@interface ViewController () <BMKSuggestionSearchDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) BMKSuggestionSearch *search;
@property (strong, nonatomic) BMKSuggestionSearchOption *option;
@property (strong, nonatomic) BMKSuggestionSearchResult *result;
@property (copy, nonatomic) BMKLocation *location;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBar becomeFirstResponder];
    // Do any additional setup after loading the view.
    if (_location == nil) {
        [LocationSingleton.sharedInstance locationOnceWithComletionBlock:^(BMKLocation * _Nullable location, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error);
                return;
            }
            self->_location = location;
        }];
    }
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
    NSMutableString *detail = [NSMutableString stringWithFormat:@"%@%@", info.city, info.district];
    if ([info.city isEqualToString:self.location.rgcData.city]) {
        CLLocation *infoLocation = [[CLLocation alloc] initWithLatitude:info.location.latitude longitude:info.location.longitude];
        [detail appendFormat:@" %.2lfkm", [infoLocation distanceFromLocation:self.location.location] / 1000];
    }
    cell.detailTextLabel.text = detail;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMKSuggestionInfo *info = self.result.suggestionList[indexPath.row];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:info.key message:[NSString stringWithFormat:@"(%lf, %lf)", info.location.latitude, info.location.longitude] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
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
        _option.cityname = _location.rgcData.city;
    }
    return _option;
}

- (void)setResult:(BMKSuggestionSearchResult *)result {
    _result = result;
    [self.tableView reloadData];
}

@end

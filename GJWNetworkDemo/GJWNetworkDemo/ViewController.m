//
//  ViewController.m
//  GJWNetworkDemo
//
//  Created by dfhb@rdd on 16/7/21.
//  Copyright © 2016年 guojunwei. All rights reserved.
//

#import "ViewController.h"
#import "GJWNetwork.h"

#import "CityItem.h"

@interface ViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *currentElementName;
@end

@implementation ViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSDictionary *param = @{@"uid":@"133825214",
                            @"interest":@"1",
                            @"count":@(20)};
    
//    [GJWNetwork configRequestType:kGJWRequestTypePlainText responseType:kGJWResponseTypeJSON];
    
    [GJWNetwork getWithUrl:@"http://116.211.167.106/api/live/aggregation" param:param success:^(GJWURLSessionTask *task, id response) {
        
        NSLog(@"response:%@", response);
        if (response) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        NSLog(@"error:%@", error);
    }];
    
    
    return;
    [GJWNetwork updateBaseUrl:@"http://101.231.204.84:8091"];
    [GJWNetwork configRequestType:kGJWRequestTypePlainText responseType:kGJWResponseTypeData];
    
    [GJWNetwork getWithUrl:@"/sim/getacptn" success:^(GJWURLSessionTask *task, id response) {
        if (response) {
            NSString *string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
        }
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        
    }];
    
    return;
    
    [self makeTableView];
    
    [GJWNetwork updateBaseUrl:@"http://api.t.dianping.com"];
    
    // 设置请求超时时间
    [GJWNetwork setTimeout:30.0f];
    
    // 设置请求数据类型，返回数据类型
    [GJWNetwork configRequestType:kGJWRequestTypeJSON responseType:kGJWResponseTypeXML];
    
    
    GJWURLSessionTask *task = [GJWNetwork getWithUrl:@"/n/base/cities.xml" param:@{@"appFlag":@"1",@"target":@"2"} success:^(GJWURLSessionTask *task, id response) {
        NSLog(@"成功--- %@", response);
        
        // xml解析
        if ([response isKindOfClass:[NSXMLParser class]]) {
            NSXMLParser *parser = (NSXMLParser *)response;
            parser.delegate = self;
            // 开始解析
            [parser parse];
        }
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        NSLog(@"失败");
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        task3.state;
        NSLog(@"%@  %@", task.taskDescription, @(task.state));
    });
//    [GJWNetwork cancelTaskWithUrl:@"home1"];
    
//    [GJWNetwork cancelAllRequest];
}
- (void)makeTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView  = tableView;
}
#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    CityItem *item = self.dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@---%@", item.name, item.enname];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"开始xml解析");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {
    
    _currentElementName = elementName;
    
    if ([elementName isEqualToString:@"city"]) {
        
        [self.dataArray addObject:[CityItem new]];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@""]) {
        return;
    }
//    NSLog(@"_currentElementName:%@ string:%@", _currentElementName, string);
    
    if (_currentElementName) {
        CityItem *item = [self.dataArray lastObject];
        if (item) {
            if ([_currentElementName isEqualToString:@"id"]) {
                item.city_id = [string integerValue];
            } else if ([_currentElementName isEqualToString:@"name"]) {
                item.name = string;
            } else if ([_currentElementName isEqualToString:@"enname"]) {
                item.enname = string;
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    self.currentElementName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
//    NSLog(@"解析完成：%@", self.dataArray);
    [self.tableView reloadData];
}

@end

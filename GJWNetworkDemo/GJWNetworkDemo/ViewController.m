//
//  ViewController.m
//  GJWNetworkDemo
//
//  Created by dfhb@rdd on 16/7/21.
//  Copyright © 2016年 guojunwei. All rights reserved.
//

#import "ViewController.h"
#import "GJWNetwork.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *tasks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GJWNetwork updateBaseUrl:@"http://m.vvgong.cn"];
    
    [GJWNetwork getWithUrl:@"home1" param:nil success:^(GJWURLSessionTask *task, id response) {
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        
    }];
    
    [GJWNetwork getWithUrl:@"home2" param:nil success:^(GJWURLSessionTask *task, id response) {
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        
    }];
    
    [GJWNetwork getWithUrl:@"home3" param:nil success:^(GJWURLSessionTask *task, id response) {
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        
    }];
    
    self.tasks = [GJWNetwork manageTasks];
    
    
    for (NSURLSessionTask *task in self.tasks) {
        NSLog(@"%@ --- %lu", task, task.taskIdentifier);
    }
    [GJWNetwork cancelAllRequest];
    NSLog(@"after");
    for (NSURLSessionTask *task in self.tasks) {
        NSLog(@"%@ --- %lu", task, task.taskIdentifier);
    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"after");
//        for (NSURLSessionTask *task in self.tasks) {
//            NSLog(@"%@ --- %lu", task, task.taskIdentifier);
//        }
//    });
}

@end

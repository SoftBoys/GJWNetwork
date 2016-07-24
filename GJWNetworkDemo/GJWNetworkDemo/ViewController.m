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
    
    [GJWNetwork getWithUrl:@"home4" param:nil success:^(GJWURLSessionTask *task, id response) {
        
    } fail:^(GJWURLSessionTask *task, NSError *error) {
        
    }];
    
    GJWFormData *data = [GJWFormData new];
    [GJWNetwork postImageWithUrl:@"home5" param:nil formData:data success:nil fail:nil];
    
    
//    [GJWNetwork cancelTaskWithUrl:@"home1"];
    
    [GJWNetwork cancelAllRequest];

}

@end

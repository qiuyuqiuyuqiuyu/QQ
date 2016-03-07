//
//  ViewController.m
//  qq分组
//
//  Created by 我不是程序员 on 16/1/14.
//  Copyright © 2016年 superRock. All rights reserved.
//

#import "ViewController.h"
//#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
//qq列表
@property (nonatomic,strong) UITableView *qqTableView;
//qq列表数据
@property (nonatomic,strong) NSDictionary *listData;
//qq列表数据allkeys
@property (nonatomic,strong) NSArray *keyListData;

@end

@implementation ViewController
{
    //bool数组判断每个分组是否打开 默认为NO
    BOOL isClose[100];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
}

- (void)creatTableView{
    [self.view addSubview:self.qqTableView];
}

#pragma mark - 懒加载
- (UITableView *)qqTableView{
    if (!_qqTableView) {
        _qqTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _qqTableView.dataSource = self;
        _qqTableView.delegate = self;
        //cell之间的分割线
        _qqTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //头视图高度
        _qqTableView.sectionHeaderHeight = 40;
    }
    return _qqTableView;
}

- (NSDictionary *)listData{
    if (!_listData) {
        NSString *listDataPath = [[NSBundle mainBundle]pathForResource:@"ListData" ofType:@"plist"];
        _listData = [NSDictionary dictionaryWithContentsOfFile:listDataPath];
    }
    return _listData;
}

- (NSArray *)keyListData{
    if (!_keyListData) {
        _keyListData = [NSArray arrayWithArray:self.listData.allKeys];
        _keyListData = [_keyListData sortedArrayUsingSelector:@selector(compare:)];
    }
    return _keyListData;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isClose[section]== YES) {
        return 0;
    }else{
        NSArray *array = [NSArray arrayWithArray:[self.listData objectForKey:[self.keyListData objectAtIndex:section]]];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSArray *sectionArray = [self.listData objectForKey:[self.keyListData objectAtIndex:indexPath.section]];
    cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
    return cell;
}
//有多少个组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listData.count;
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //可以不用设置返回view的frame
    //    button.frame = CGRectMake(100, 100, 100, 100);
    [button setTitle:[self.keyListData objectAtIndex:section] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    //    button.backgroundColor = RandomColor;
    button.backgroundColor = [UIColor lightGrayColor];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = section+100;
    return button;
}

//头视图点击方法
- (void)buttonAction:(UIButton *)button{
    isClose[button.tag-100] = !isClose[button.tag-100];
    //    NSLog(@"%ld",button.tag);
    [self.qqTableView reloadData];
}
@end

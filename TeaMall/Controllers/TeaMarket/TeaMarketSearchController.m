//
//  TeaMarketSearchController.m
//  茶叶市场的主界面
//
//  Created by Carl_Huang on 14-8-26.
//  Copyright (c) 2014年 HelloWorld. All rights reserved.
//
//定义颜色的宏
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
//teaMarketSearchController模块
//分割线背景
#define kSeparateLineBg kColor(211, 211, 211)
//tableViewcell背景
#define kTableViewCellBg kColor(232, 233, 232)
//searchView背景
#define kSearchViewBg kColor(236, 236, 236)
//table的边距
#define kTableViewCellBorder 20

#import "TeaMarketSearchController.h"
#import "ControlCenter.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "TeaCategory.h"
#import "HeadView.h"

@interface TeaMarketSearchController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HeadViewDelegate>

{
    
    //搜索控件
//    UITextField *_searchText;
    //搜索字符串
    NSString *_searchStr;
    //表格控件
//    UITableView *_tableView;
    // 头部列表
    NSMutableArray *_headerList;
    
    NSInteger _currentSection;
    NSInteger _currentRow;
    
    //年份
    NSArray *_years;
    
    // 表格展开情况记录字典,如果是展开,记录1|如果是折叠,记录0
//    NSMutableDictionary *_sectionInfo;
}

@end

@implementation TeaMarketSearchController


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //创建页面
    [self setupUI];
//    [self bulidUI];
    //加载数据
//    [self loadData];
    //添加手势
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    NSLog(@"self.subViews:%@",self.view.subviews);
//    [_contentTable setBackgroundColor:[UIColor redColor]];
    //创建年份数组
    [self createYears];
    //加载数据
    [self getAllTeaCategory];
}

- (void)createYears
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for(int i = 0 ; i <= 17; i ++)
    {
        int year = 2014 - i;
        [arrayM addObject:[NSString stringWithFormat:@"%i",year]];
    }
    _years = arrayM;
}

#pragma mark 建立UI界面
- (void)setupUI
{
    NSLog(@"self.view:%@",NSStringFromCGRect(self.view.frame));
    self.title = @"搜索";
    _searchBar.delegate = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //修改SearchBar风格
    self.searchBar.layer.cornerRadius=15.0f;
    self.searchBar.layer.borderColor = [[UIColor redColor] CGColor];
    self.searchBar.layer.borderWidth = 1.0;
}

#pragma mark 获取所有分类
- (void)getAllTeaCategory
{
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    if(appDelegate.allTeaCategory == nil)
    {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
        [[HttpService sharedInstance] getCategory:@{@"is_system":@"0"} completionBlock:^(id object) {
            
            [hud hide:YES];
            appDelegate.allTeaCategory = object;
            [self loadModel];
            [self.contentTable reloadData];
        } failureBlock:^(NSError *error, NSString *responseString) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加载失败";
            [hud hide:YES afterDelay:1.0];
        }];
    }
    else
    {
        [self loadModel];
    }
    
}


- (void)loadModel{
    _currentRow = -1;
    _headerList = [[NSMutableArray alloc]init ];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    for(int i = 0;i< [appDelegate.allTeaCategory count] ;i++)
	{
        TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:i];
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
		headview.section = i;
        headview.tag = i;
        [headview.backBtn setTitle:[NSString stringWithFormat:@"  %@",category.name] forState:UIControlStateNormal];
        [headview.backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [headview setBackgroundColor:kTableViewCellBg];
        [headview.backBtn setBackgroundImage:nil forState:UIControlStateNormal];
		[_headerList addObject:headview];
        headview = nil;
	}
}

#pragma mark 手势响应，退出键盘
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_searchBar resignFirstResponder];
}

#pragma mark 搜索按钮监听方法
- (void)searchClick
{
//    [self textFieldShouldReturn:_searchText];
    NSLog(@"%@",_searchStr);
}

/*
#pragma mark --建立UI
- (void)bulidUI
{
    self.title = @"搜索";
    
    //添加搜索栏,64 = 20（状态栏） +44(导航栏)
    //搜索栏的View，占位视图
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 44)];
    searchView.backgroundColor = kSearchViewBg;
    
    //搜索textfield
    UITextField *searchText = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, searchView.bounds.size.width*0.75 - 10, 44-10)];
    //设置searchText风格
    searchText.layer.cornerRadius=20.0f;
    searchText.layer.borderColor = [[UIColor redColor] CGColor];
    searchText.layer.borderWidth = 1.0;
    
    searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchText.delegate = self;
    searchText.borderStyle = UITextBorderStyleRoundedRect;
    searchText.placeholder = @"搜搜你喜欢的商品";
    [searchView addSubview:searchText];
//    _searchText = searchText;
    
    //所搜栏的按钮
    UIButton *searchBtn = [[UIButton alloc ]initWithFrame:CGRectMake(searchView.bounds.size.width*0.75, 0, searchView.bounds.size.width*0.25, 44)];
    [searchBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [searchBtn setTitle:@"确定" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    
    [self.view addSubview:searchView];
    
    //“分类”label
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTableViewCellBorder, 64 + searchView.bounds.size.height, self.view.bounds.size.width, 44)];
    [headerLabel setTextColor:[UIColor lightGrayColor]];
    headerLabel.text = @"分类";
    
    //分割线
    UIImageView *separateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, headerLabel.bounds.size.height - 10, self.view.bounds.size.width - 2*kTableViewCellBorder, 2)];
    [separateLine setBackgroundColor:kSeparateLineBg];
    
    [headerLabel addSubview:separateLine];
    
    [self.view addSubview:headerLabel];
    
    //添加tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(kTableViewCellBorder, 44 + 64 + searchView.bounds.size.height, self.view.bounds.size.width - 2*kTableViewCellBorder, self.view.frame.size.height - 64 - 44 -  searchView.bounds.size.height)];
    //取消滚动条
    tableView.showsVerticalScrollIndicator = NO;
    _tableView = tableView;
    //设置数据源与代理
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:tableView];
}
*/

//#pragma mark --加载数据
//- (void)loadData
//{
//    // 初始化数据
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"friends" ofType:@"plist"];
//    _headerList = [NSArray arrayWithContentsOfFile:path];
//    
//    // 初始化折叠情况记录字典
//    _sectionInfo = [NSMutableDictionary dictionaryWithCapacity:_headerList.count];
//    for (NSInteger i = 0; i < _headerList.count; i++) {
//        // 默认都是折叠的
//        NSDictionary *dict = _headerList[i];
//        [_sectionInfo setValue:@0 forKey:dict[@"group"]];
//    }
//}

#pragma mark - Tableview 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据indexPath中的sction属性,取出对应的teaList数组,并且返回该数组的数量
    // 该数组中就是sction分组对应的好友列表
//    NSDictionary *dict = _headerList[section];
    
    // 如果分组信息的字典中数值为0,表示折叠,直接返回0
//    NSInteger i = [_sectionInfo[dict[@"group"]]integerValue];
//    if (i == 0) {
//        return 0;
//    } else {
//        NSArray *array = dict[@"friends"];
//        
//        return array.count;
//    }
    HeadView* headView = [_headerList objectAtIndex:section];
    return headView.open?[_years count]:0;
}

#pragma mark 分组头部
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    /*
    // 分组的头也需要做优化,
    // 注意:如果需要分组头优化,需要使用xib文件自定义分组头,或者使用代码的方式自定义分组头控件
    static NSString *HeaderID = @"myHeader";
    UIView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
    
    if (myHeader == nil) {
        myHeader = [[UIView alloc]init];
//        NSLog(@"建立表格标题");
        [myHeader setBackgroundColor:kTableViewCellBg];
    }
    
    // 增加三角指示图片
    UIImage *image = [UIImage imageNamed:@"disclosure.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView setFrame:CGRectMake(240, 4, 32, 32)];
    [myHeader addSubview:imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 320, 40)];
    //按钮的对齐方式
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitle:@"header" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 用button的tag属性记录section数值
    [button setTag:section];
    // 监听按钮事件
    [button addTarget:self action:@selector(clickHeader:) forControlEvents:UIControlEventTouchUpInside];
    
    [myHeader addSubview:button];
    
//    // 可以根据对应的sction设定三角图片的旋转角度
//    NSDictionary *dict = _headerList[section];
//    NSInteger sectionStatus = [_sectionInfo[dict[@"group"]]integerValue];
//    // 如果是0,表示折叠, 如果是1,表示展开,旋转90
//    
//    if (sectionStatus == 0) {
//        [imageView setTransform:CGAffineTransformMakeRotation(0)];
//    } else {
//        [imageView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
//    }
    */
    
//    static NSString *HeaderID = @"myHeader";
//    HeadView *myHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderID];
//    
//    if (myHeader == nil) {
//        myHeader = [[HeadView alloc]init];
//        myHeader.delegate = self;
//        myHeader.tag = section;
//        //        NSLog(@"建立表格标题");
//        [myHeader setBackgroundColor:kTableViewCellBg];
//        [myHeader.backBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [myHeader.backBtn setBackgroundImage:nil forState:UIControlStateNormal];
//    }
//    TeaCategory *category = _headerList[section];
//    [myHeader.backBtn setTitle:[NSString stringWithFormat:@"  %@",category.name] forState:UIControlStateNormal];
    return [_headerList objectAtIndex:section];
}

//#pragma mark - 点击头部按钮监听方法
//- (void)clickHeader:(UIButton *)button
//{
//    NSLog(@"点我了");
//    
    // 1. 知道点击的sction
//    NSInteger section = button.tag;
    // 根据sctionInfo中的数值求反就可了.
    // 1.1 先从friendList中取出对应的字典
//    NSDictionary *dict = _headerList[section];
    // 1.2 从字典中取出组名
//    NSString *groupName = dict[@"group"];
    // 1.3 设置sctionInfo中的数值
//    NSInteger sectionNumber = [_sectionInfo[groupName]integerValue];
    
//    [_sectionInfo setValue:@(!sectionNumber) forKey:groupName];
    
    
//#warning 加载数据
//      [[HttpService sharedInstance] getCategory:@{@"is_system":@"0"} completionBlock:^(id object) {
//          NSLog(@"category:%@",object);
//      } failureBlock:^(NSError *error, NSString *responseString) {
//          NSLog(@"加载失败");
//      }];
    
    // 刷新所有数据
//    [_contentTable reloadData];
//}

#pragma mark - 返回每个头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _years[indexPath.row];
    return cell;
}


#pragma mark textfield代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _searchStr = textField.text;//取出搜索的文字
    
    [textField resignFirstResponder];//退出键盘
    return YES;
}


#pragma mark 搜索按钮确定方法
- (IBAction)sure:(id)sender {
}

#pragma mark - HeadViewdelegate
- (void)selectedWith:(HeadView *)view viewTag:(NSInteger)tag{
    _currentRow = -1;
    if (view.open) {
        for(int i = 0;i<[_headerList count];i++)
        {
            if (tag == i) {
                HeadView *head = [_headerList objectAtIndex:i];
                head.open = NO;
//#warning 分类底不是一张白色图片吗？为什么不直接设置背景颜色为白色，这样可以提高效率
//                [head.backBtn setBackgroundImage:[UIImage imageNamed:@"分类底"] forState:UIControlStateNormal];
                [head.indicatorBtn setSelected:NO];
            }
            
        }
        [self.contentTable reloadData];
        return;
    }
    _currentSection = view.section;
    [self reset];
    
    
    NSLog(@"点击第%d组",tag);
    
    
}

- (void)reset
{
    for(int i = 0;i<[_headerList count];i++)
    {
        HeadView *head = [_headerList objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            [head.indicatorBtn setSelected:YES];
//            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"分类底"] forState:UIControlStateNormal];
            
        }
        //        else {
        //            [head.backBtn setBackgroundImage:[UIImage imageNamed:@"产品展示底框"] forState:UIControlStateNormal];
        //            [head.indicatorBtn setSelected:NO];
        //            head.open = NO;
        //        }
        
    }
    [self.contentTable reloadData];
}


#pragma mark 选中某个cell执行的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRow = indexPath.row;
    [self.contentTable reloadData];
    AppDelegate * appDelegate = [ControlCenter appDelegate];
    TeaCategory * category = [appDelegate.allTeaCategory objectAtIndex:indexPath.section];
    NSString * year = [_years objectAtIndex:indexPath.row];
    TeaMarketViewController *vc = [[TeaMarketViewController alloc] init];
    vc.year = year;
    vc.teaCategory = category;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

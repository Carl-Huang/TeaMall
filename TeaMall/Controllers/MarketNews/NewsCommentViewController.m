//
//  NewsCommentViewController.m
//  TeaMall
//
//  Created by Carl on 14-4-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "TeaCommentSelfCell.h"
#import "TeaCommentOtherCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "HttpService.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "NewsComment.h"
@interface NewsCommentViewController ()
@property (nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,strong) MJRefreshFooterView * refreshFooterView;
@property (nonatomic,strong) User * user;
@end

@implementation NewsCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [@[] mutableCopy];
        _currentPage = 0;
        _user = [User userFromLocal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self setLeftCustomBarItem:@"返回" action:nil];
    UINib * otherNib = [UINib nibWithNibName:@"TeaCommentOtherCell" bundle:[NSBundle bundleForClass:[TeaCommentOtherCell class]]];
    UINib * selfNib = [UINib nibWithNibName:@"TeaCommentSelfCell" bundle:[NSBundle bundleForClass:[TeaCommentSelfCell class]]];
    [_tableView registerNib:otherNib forCellReuseIdentifier:@"OtherCell"];
    [_tableView registerNib:selfNib forCellReuseIdentifier:@"SelfCell"];
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:view];
    view = nil;
    [self loadNewsComment];
    
    __weak NewsCommentViewController * weakSelf = self;
    _refreshFooterView = [[MJRefreshFooterView alloc] initWithScrollView:_tableView];
    _refreshFooterView.beginRefreshingBlock = ^(MJRefreshBaseView * baseView){
        [weakSelf loadNewsComment];
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadNewsComment
{
    _currentPage += 1;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    [[HttpService sharedInstance] getNewsComment:@{@"news_id":_newsID,@"page":[NSString stringWithFormat:@"%i",_currentPage],@"pageSize":@"15"} completionBlock:^(id object) {
        if(object == nil || [object count] == 0)
        {
            hud.labelText = @"没有更多评论";
            if(_currentPage == 1)
            {
                hud.labelText = @"暂时没有评论";
            }
            [hud hide:YES afterDelay:1];
            return ;
        }
        
        
        if(_currentPage)
        {
            _dataSource = [object mutableCopy];
        }
        else
        {
            [_dataSource addObjectsFromArray:object];
        }
        [hud hide:YES];
        [_tableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
    }];
}


#pragma mark - UITableViewDataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsComment * comment = _dataSource[indexPath.row];
    id cell;
    if(_user != nil)
    {
        if([comment.user_id isEqualToString:_user.hw_id])
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"SelfCell"];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
    }
    NSDate * date = [NSDate dateFromString:comment.comment_time withFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * timeStr = [date formatDateString:@"mm:ss"];
    if([cell isKindOfClass:[TeaCommentOtherCell class]])
    {
        TeaCommentOtherCell * otherCell = (TeaCommentOtherCell *)cell;
        [otherCell.avatar setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"头像1"]];
        otherCell.userNameLabel.text = [comment.account stringByAppendingString:@":"];
        otherCell.contentLabel.text = comment.content;
        otherCell.timeLabel.text = timeStr;
        
    }
    else if([cell isKindOfClass:[TeaCommentSelfCell class]])
    {
        TeaCommentSelfCell * selfCell = (TeaCommentSelfCell *)cell;
        [selfCell.avatar setImageWithURL:[NSURL URLWithString:comment.avatar] placeholderImage:[UIImage imageNamed:@"头像1"]];
        selfCell.userNameLabel.text = [comment.account stringByAppendingString:@":"];
        selfCell.contentLabel.text = comment.content;
        selfCell.timeLabel.text = timeStr;
    }
    
    return cell;
}


#pragma mark - Keyboard
- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    NSLog(@"%@",[info valueForKey:UIKeyboardFrameEndUserInfoKey]);
    NSLog(@"%f",self.view.frame.origin.y);
    CGRect keyboardRect = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame =  CGRectMake(0,keyboardRect.origin.y - self.view.frame.size.height - ([OSHelper iOS7]?0:64), self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)keyboardHide:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    NSLog(@"%@",[info valueForKey:UIKeyboardFrameEndUserInfoKey]);
    
    //CGRect keyboardRect = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, [OSHelper iOS7]?64:0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}


- (IBAction)submitAction:(id)sender
{
    [_contentField resignFirstResponder];
    if([_contentField.text length] == 0)
    {
        return ;
    }
    User * user = [User userFromLocal];
    if(user == nil)
    {
        [self showAlertViewWithMessage:@"请先登录."];
        return ;
    }
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交中...";
    [[HttpService sharedInstance] addNewsComment:@{@"news_id":_newsID,@"user_id":user.hw_id,@"content":_contentField.text} completionBlock:^(id object) {
        hud.labelText = @"评论成功";
        [hud hide:YES afterDelay:1];
    } failureBlock:^(NSError *error, NSString *responseString) {
        hud.labelText = @"评论失败";
        [hud hide:YES afterDelay:1];
    }];
    
}

- (IBAction)endEdit:(id)sender
{
    [_contentField resignFirstResponder];
}

@end

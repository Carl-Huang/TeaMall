//
//  PersonalInfoViewController.m
//  TeaMall
//
//  Created by Carl on 14-2-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MyAddressViewController.h"
#import "ChangeSexViewController.h"
#import "ChangeNameViewController.h"
#import "ChangePhoneViewController.h"
#import "User.h"
@interface PersonalInfoViewController ()
@property (nonatomic,strong) User * user;
@end

@implementation PersonalInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCustomBarItem:@"返回" action:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _user = [User userFromLocal];
    if(_user.account)
    {
        _nameLabel.text = _user.account;
    }
    else
    {
        _nameLabel.text = @"";
    }
    
    if(_user.sex)
    {
        if([_user.sex isEqualToString:@"1"])
        {
            _sexLabel.text = @"男";
        }
        else
        {
            _sexLabel.text = @"女";
        }
    }
    else
    {
        _sexLabel.text = @"";
    }
    
    if(_user.phone)
    {
        _phoneLabel.text = _user.phone;
    }
    else
    {
        _phoneLabel.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tabkePictureAction:(id)sender
{
    
}

- (IBAction)showAddressAction:(id)sender
{
    MyAddressViewController * vc = [[MyAddressViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeNameAction:(id)sender
{
    ChangeNameViewController * vc = [[ChangeNameViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changeSexAction:(id)sender
{
    ChangeSexViewController * vc = [[ChangeSexViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}

- (IBAction)changePhoneAction:(id)sender
{
    ChangePhoneViewController * vc = [[ChangePhoneViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
}
@end

//
//  MemberController.m
//  Happy Shopping
//
//  Created by Robert on 2017/9/11.
//  Copyright © 2017年 rwkpq3431ed@126.com. All rights reserved.
//

#import "MemberController.h"

@interface MemberController ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *invitation;
@property (weak, nonatomic) IBOutlet UILabel *opinion;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end

@implementation MemberController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.question.font = [UIFont fontWithName:TextFont size:kSize(17)];
    self.invitation.font = [UIFont fontWithName:TextFont size:kSize(17)];
    self.opinion.font = [UIFont fontWithName:TextFont size:kSize(17)];
    self.score.font = [UIFont fontWithName:TextFont size:kSize(17)];
    self.moreLabel.font = [UIFont fontWithName:TextFont size:kSize(17)];
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
- (void)viewDidLayoutSubviews{
    
    self.headImg.layer.cornerRadius = self.headImg.height*0.5;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)initData{
    
    //头像
    AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
    if (![ETRegularUtil isEmptyString:file.url]) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageBundleNamed:@"member_default.png"]];
    }else{
        self.headImg.image = [UIImage imageBundleNamed:@"member_default.png"];
    }
    
    //用户名
    NSString *name = [[AVUser currentUser] objectForKey:@"name"];
    if (![ETRegularUtil isEmptyString:name]) {
        self.nickName.text = name;
    }else{
        NSString *username = [[AVUser currentUser] objectForKey:@"username"];
        if (![ETRegularUtil isEmptyString:username]) {
            self.nickName.text = username;
        }else{
            self.nickName.text = @"username";
        }
    }
}

- (IBAction)selectMyInfo:(UITapGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag;
    switch (tag) {
        case 0:{
            MyQuestionController *vc = [[MyQuestionController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1343598683?mt=8"];
            UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[url] applicationActivities:nil];
            [self.navigationController presentViewController:activityController animated:YES completion:nil];
        }
            break;
        case 2:{
            
            MyFeedbackController *vc = [[MyFeedbackController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",APPID];
            NSURL *url = [NSURL URLWithString:str];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@ {UIApplicationOpenURLOptionUniversalLinksOnly:@NO} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL: url];
            }
        }
            break;
        case 4:{
            
            MoreController * vc = [[MoreController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 5:{
            MyInfoController *vc = [[MyInfoController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end

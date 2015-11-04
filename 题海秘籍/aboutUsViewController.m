//
//  aboutUsViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/10/10.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "aboutUsViewController.h"

@interface aboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *T1;
@property (weak, nonatomic) IBOutlet UILabel *T2;
@property (weak, nonatomic) IBOutlet UILabel *T3;
@property (weak, nonatomic) IBOutlet UILabel *T4;
@property (weak, nonatomic) IBOutlet UILabel *T5;
@property (weak, nonatomic) IBOutlet UILabel *T6;
@property (weak, nonatomic) IBOutlet UILabel *T7;

@end

@implementation aboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.T1.alpha = 0;
    self.T2.alpha = 0;
    self.T3.alpha = 0;
    self.T4.alpha = 0;
    self.T5.alpha = 0;
    self.T6.alpha = 0;
    self.T7.alpha = 0;
    for (UILabel *label in self.view.subviews) {
//        label.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
        label.alpha =1;
        [UIView commitAnimations];
    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.T1.alpha = 0;
//        self.T1.alpha = 1;
//        self.T2.alpha = 1;
//    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

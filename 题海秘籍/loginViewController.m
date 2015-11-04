//
//  loginViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/10.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "loginViewController.h"
#import "MBProgressHUD+NJ.h"
#import "quetionSelectTableViewController.h"


@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *keyField;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UISwitch *leftBtn;
@property (weak, nonatomic) IBOutlet UISwitch *rightBtn;

@end

@implementation loginViewController


- (IBAction)loginBtn:(id)sender {
    [MBProgressHUD showMessage:@"正在拼命加载"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        if ([self.keyField.text isEqualToString:@"888888"]) {
            [self performSegueWithIdentifier:@"loginToquestion" sender:nil];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.nameField.text forKey:@"name"];
            [defaults setObject:self.keyField.text forKey:@"key"];
            [defaults setBool:self.leftBtn.on forKey:@"leftSwicth"];
            [defaults setBool:self.rightBtn.on forKey:@"rightSwicth"];
        }else{
            [MBProgressHUD showError:@"密码错误！"];
        }
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.nameField];
    [center addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:self.keyField];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.leftBtn.on = [defaults boolForKey:@"leftSwicth"];
    self.rightBtn.on = [defaults boolForKey:@"rightSwicth"];
    self.nameField.text = [defaults objectForKey:@"name"];
    if (self.leftBtn.on) {
        self.keyField.text = [defaults objectForKey:@"key"];
    }
    [self textChange];
    if (self.rightBtn.on) {
        [self loginBtn:nil];
        [MBProgressHUD hideHUD];
    }
}

-(void)textChange{
    self.login.enabled =(self.nameField.text.length && self.keyField.text.length);
}
- (IBAction)resignKeyborad:(id)sender {
    [self.nameField resignFirstResponder];
    [self.keyField resignFirstResponder];
}

- (IBAction)leftSwitchOnclick:(id)sender {
    if (!self.leftBtn.on) {
        [self.rightBtn setOn:NO animated:true];
    }
}
- (IBAction)rightSwitchOnlick:(id)sender {
    if (self.rightBtn) {
        [self.leftBtn setOn:YES animated:true];
    }
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

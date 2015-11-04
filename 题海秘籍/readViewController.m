//
//  readViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/10/2.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "readViewController.h"
#import "MBProgressHUD+NJ.h"
@interface readViewController ()
@property (weak, nonatomic) IBOutlet UITextView *topicTextField;
@property (weak, nonatomic) IBOutlet UIView *optionalView;
@property (weak, nonatomic) IBOutlet UILabel *answer;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *item;
@property (nonatomic ,assign)NSInteger time;
@property (nonatomic ,strong)NSMutableArray *temp;
@property (nonatomic ,strong)UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic ,strong)UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic ,assign)CGFloat myfont;
@property (nonatomic ,assign)CGFloat interval;
@property (weak, nonatomic) IBOutlet UITextField *goTo;
@property (nonatomic ,strong)NSMutableArray *btnArr;

@end

@implementation readViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didMyFont];
    self.topicTextField.font = [UIFont systemFontOfSize:_myfont+1];
    self.answer.font = [UIFont systemFontOfSize:_myfont+1];
    self.answerLabel.font = [UIFont systemFontOfSize:_myfont+1];
    [self didbtn];
    [self setSwipeGesture];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(selected) name:UITextFieldTextDidEndEditingNotification object:self.goTo];
    
    if (![self.record isEqual:@"wrong"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.time = [defaults integerForKey:self.record];               //获取用户记录。
        if (self.time == self.tpic.count-1) {
            self.nextBtn.enabled = NO;
        }
        if (self.time == 0) {
            self.lastBtn.enabled = NO;
        }
    }
    if (self.tpic.count == 1) {
        self.nextBtn.enabled = NO;
        self.lastBtn.enabled = NO;
    }
    [self setBtnTitle];
}
-(void)selected{
    NSInteger i = self.goTo.text.integerValue;
    if ([self.goTo.text isEqual:@""]) {
        return ;
    }
    if (i <= self.tpic.count && i > 0) {
        self.time = i;
        self.lastBtn.enabled =YES;
        [self lastBtnOnclick:nil];
    }else{
        [MBProgressHUD showError:@"请不要超出题目范围"];
    }
    self.goTo.text = @"";
}
- (IBAction)resignFirst:(id)sender {
    [self.goTo resignFirstResponder];
}

-(void)didMyFont{
    if (self.view.frame.size.height == 480) {
        _myfont = 12;
        _interval = 35;
    }
    else if(self.view.frame.size.height == 568){
        _myfont = 12;
        _interval = 48;
    }
    else if(self.view.frame.size.height == 667){
        _myfont = 15;
        _interval = 55;
    }
    else{
        _myfont = 15;
        _interval = 60;
    }
//    NSLog(@"_interval = %f",_interval);
}
-(void)setSwipeGesture{
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextBtnOnclick:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(lastBtnOnclick:)];
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
}

- (IBAction)getBack:(UIBarButtonItem *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.time forKey:self.record];
    [self.navigationController popViewControllerAnimated:true];
}
-(void)didbtn{
    for (int i = 0; i < 5; i++) {
        CGFloat Y = i*_interval;
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(5, Y, self.optionalView.frame.size.width, _interval);
        btn.titleLabel.font = [UIFont systemFontOfSize:_myfont];
        btn.enabled = NO;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btn.titleLabel.lineBreakMode = 0;
        CATransition *ca = [CATransition animation];
        ca.type = @"fade";
        [btn.layer addAnimation:ca forKey:nil];
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        btn.tag = i;
        [self.optionalView addSubview:btn];
        [self.btnArr addObject:btn];
    }
    
}
-(NSMutableArray *)btnArr{
    if (_btnArr ==nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

-(void)setBtnTitle{
    self.temp= self.tpic[self.time];
    
    NSString *tp = [NSString stringWithString:self.temp[0]];
    NSMutableString *title = [NSMutableString stringWithString:tp];
    int n = 4-(int)tp.length/20;
    if (n>0) {
        for (int i =0; i < n ; i++) {
            [title insertString:@"\n" atIndex:0];
        }
    }
    
    UIButton *btnC = self.btnArr[2];
    UIButton *btnD = self.btnArr[3];
    UIButton *btnE =self.btnArr[4];
    self.topicTextField.text = title;
    if (self.temp.count == 6) {
        UIButton *btnE =self.btnArr[4];
        btnC.alpha = 1;
        btnD.alpha = 1;
        btnE.alpha = 0;
    }else if (self.temp.count == 4) {
        btnC.alpha = 0;
        btnD.alpha = 0;
        btnE.alpha = 0;
    }else if(self.temp.count == 7){
        btnC.alpha = 1;
        btnD.alpha = 1;
        btnE.alpha = 1;
    }
    for (int i = 0; i < self.temp.count -2; i++) {
        UIButton *btn = self.btnArr[i];
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
//        ca.subtype =@"fromTop";
        [btn.layer addAnimation:ca forKey:nil];
        [btn setTitle:[NSString stringWithFormat:@"%@",self.temp[i+1]] forState:UIControlStateNormal];
        [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    [self.answer setText:[self.temp lastObject]];
    [self.item setTitle:[NSString stringWithFormat:@"%ld/%lu",self.time+1,(unsigned long)self.tpic.count]];
    
}

- (IBAction)lastBtnOnclick:(id)sender {
    if (!self.lastBtn.enabled) {
        return;
    }
    self.nextBtn.enabled = YES;
    self.time --;
    [self setBtnTitle];
    CATransition *ca = [CATransition animation];
    ca.type =@"cube";
    ca.subtype =@"fromBottom";
    [self.topicTextField.layer addAnimation:ca forKey:nil];
    if (self.time == 0) {
        self.lastBtn.enabled = NO;
    }else if(self.time == self.tpic.count -1){
        self.nextBtn.enabled = NO;
        self.lastBtn.enabled = YES;
    }
}

- (IBAction)nextBtnOnclick:(id)sender {
    if (!self.nextBtn.enabled) {
        return;
    }
    self.lastBtn.enabled = YES;
    self.time ++;
    [self setBtnTitle];
    CATransition *ca = [CATransition animation];
    ca.type =@"cube";
    ca.subtype =@"fromTop";
    [self.topicTextField.layer addAnimation:ca forKey:nil];
    if (self.time == self.tpic.count -1) {
        self.nextBtn.enabled = NO;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)tpic{
    if (_tpic == nil) {
        _tpic = [NSMutableArray array];
    }
    return _tpic;
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

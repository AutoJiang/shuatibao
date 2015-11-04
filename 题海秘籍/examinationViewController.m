//
//  examinationViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/30.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "examinationViewController.h"
#import "QCheckBox.h"
#import "MBProgressHUD+NJ.h"
#import "readViewController.h"
#define S 5
#define M 10
@interface examinationViewController ()
@property (nonatomic ,assign) NSInteger time;
@property (weak, nonatomic) IBOutlet UITextView *topicTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *optionalView;
@property (nonatomic,strong)UIButton *btn;
@property (nonatomic ,strong)NSMutableArray *btnArray;
@property (nonatomic ,strong)NSMutableArray *btnArrayD;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *item;
@property (nonatomic ,strong)NSMutableArray *temp;
@property (nonatomic ,assign)NSInteger right;
@property (strong,nonatomic) NSMutableArray *wrong;
@property (nonatomic ,strong)NSMutableArray *check;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign)NSInteger secondsCountDown;
@property (nonatomic,strong)NSTimer *countDownTimer;
@property (nonatomic ,assign)CGFloat myfont;
@property (nonatomic ,assign)CGFloat interval;
@property (nonatomic ,assign)NSInteger grade;
@end
@implementation examinationViewController


-(void)didMyFont{
    if (self.view.frame.size.height == 480) {
        _myfont = 13;
        _interval = 40;
    }
    else if(self.view.frame.size.height == 568){
        _myfont = 14;
        _interval = 48;
    }
    else if(self.view.frame.size.height == 667){
        _myfont = 15;
        _interval = 52;
    }
    else{
        _myfont = 15;
        _interval =50;
    }
    self.topicTextField.font= [UIFont systemFontOfSize:_myfont];
//    NSLog(@"_myfont = %f",_myfont);
}
- (IBAction)getBack:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未完成全部答题，是否确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defauts = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:defauts];
    [self presentViewController:alert animated:true completion:nil];
}

-(void)didBtn{
    for (int i = 0; i < 4; i++) {
        CGFloat Y = i*(_interval+10);
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, Y, self.optionalView.frame.size.width, _interval);
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        btn.titleLabel.font = [UIFont systemFontOfSize:_myfont];
        btn.titleLabel.lineBreakMode = 0;
        btn.alpha = 0.8;
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_0"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_1"] forState:UIControlStateHighlighted];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.optionalView addSubview:btn];
        [self.btnArray addObject:btn];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self didMyFont];
//    self.navigationController.navigationBar.translucent =YES;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.secondsCountDown = 1200;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",self.secondsCountDown/60,self.secondsCountDown%60];
    self.timeLabel.font= [UIFont systemFontOfSize:_myfont];
//    self.timeLabel.style = UIBarButtonItemStyleDone;
    [self didBtn];
    [self setBtnTitle];
}


-(void)timeFireMethod{
    self.secondsCountDown--;
    self.timeLabel.text = [NSString stringWithFormat:@"%ld:%02ld",self.secondsCountDown/60,self.secondsCountDown%60];
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        [self complete];
//        [self.timeLabel removeFromSuperview];
    }
}

-(NSMutableArray *)btnArray{
    if (_btnArray ==nil) {
        _btnArray =[[NSMutableArray alloc]init];
    }
    return _btnArray;
}
-(NSMutableArray *)btnArrayD{
    if (_btnArrayD ==nil) {
        _btnArrayD =[NSMutableArray array];
    }
    return _btnArrayD;
}
-(NSArray *)check{
    if (_check ==nil) {
        _check = [NSMutableArray arrayWithCapacity:5];
    }
    return _check;
}
-(void)setBtnTitle{
    self.time++;
    if (self.time <= S) {
        NSInteger n = arc4random() % self.singleTpic.count;
        self.temp= self.singleTpic[n];
//        NSLog(@"%@",[self.temp lastObject]); 检测答案
        [self.singleTpic removeObjectAtIndex:n];
        NSString *tp = [NSString stringWithString:self.temp[0]];
        NSMutableString *title = [NSMutableString stringWithString:tp];
        int m = 4-(int)tp.length/20;
        if (m>0) {
            for (int i =0; i < m ; i++) {
                [title insertString:@"\n" atIndex:0];
            }
        }
        self.topicTextField.text = title;
        
        CATransition *ca = [CATransition animation];
        ca.type =@"cube";
        ca.subtype =@"fromTop";
        [self.topicTextField.layer addAnimation:ca forKey:nil];
        UIButton *btnA = self.btnArray[0];
        UIButton *btnB = self.btnArray[1];
        [btnA.layer addAnimation:ca forKey:nil];
        [btnB.layer addAnimation:ca forKey:nil];
        if (self.temp.count == 4) {                        //判断题识别 
            UIButton *btnC = self.btnArray[2];
            [btnC setTitle:@"" forState:UIControlStateNormal];
            btnC.enabled = NO;
            UIButton *btnD = self.btnArray[3];
            [btnD setTitle:@"" forState:UIControlStateNormal];
            btnD.enabled = NO;
        }else{
            UIButton *btnC = self.btnArray[2];
            btnC.enabled = YES;
            UIButton *btnD = self.btnArray[3];
            btnD.enabled = YES;
            [btnC.layer addAnimation:ca forKey:nil];
            [btnD.layer addAnimation:ca forKey:nil];
        }
        for (int i = 0; i< self.temp.count -2; i++) {
            UIButton *btn = self.btnArray[i];
            [btn setTitle:[NSString stringWithFormat:@"%@",self.temp[i+1]] forState:UIControlStateNormal];
            [btn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        }
        [self.item setTitle:[NSString stringWithFormat:@"%ld/%d",(long)self.time,M]];
    }
    if (self.time == S) {
        for (UIView *view in [self.optionalView subviews]){
            if ([view isKindOfClass:[UIButton class]])
                [view removeFromSuperview];
        }
        self.btn = [UIButton buttonWithType:UIButtonTypeSystem];
        CGFloat wight = self.view.frame.size.width;
        CGFloat height= self.view.frame.size.height;
        self.btn.frame = CGRectMake(0.1*wight, height*0.9, 0.8*wight,height*0.05 );
        [self.btn addTarget:self action:@selector(btnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn setTitle:@"确定" forState:UIControlStateNormal];
//        [self.btn setBackgroundColor:[UIColor greenColor]];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"btn_1"] forState:UIControlStateNormal];
        [self.view addSubview:self.btn];
        [self initcheck];
        
        for (int i = 0; i < 5; i++) {
            CGFloat y = i * 40;
            QCheckBox  *check = [[QCheckBox alloc]initWithDelegate:self];
            check.frame = CGRectMake(0, y, self.optionalView.frame.size.width, 40);
            check.tag = i;
            check.titleLabel.lineBreakMode = 0;
            [check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [check setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            [check setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
            [check.titleLabel setFont:[UIFont boldSystemFontOfSize:_myfont]];
            [check setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
            [check setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
            [self.optionalView addSubview:check];
            [self.btnArrayD addObject:check];
        }
        
    }
    if (self.time >=S) {
        [self clearSelect];
        NSInteger n = arc4random()%self.doubleTpic.count;
        self.temp = self.doubleTpic[n];
        [self.doubleTpic removeObjectAtIndex:n];
        self.topicTextField.text = self.temp[0];
//        self.time++;
        [self.item setTitle:[NSString stringWithFormat:@"%ld/%d",(long)self.time,M]];
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
        ca.subtype =@"fromTop";
        [self.topicTextField.layer addAnimation:ca forKey:nil];
        if (self.temp.count == 6) {
            UIButton *btn =self.btnArrayD[4];
            btn.alpha = 0;
        }else{
            UIButton *btn =self.btnArrayD[4];
            btn.alpha = 1;
        }
        for (int i = 0 ; i< self.temp.count -2; i++) {
            QCheckBox *btn = self.btnArrayD[i];
            [btn setTitle:self.temp[i+1] forState:UIControlStateNormal];
            CATransition *ca = [CATransition animation];
            ca.type = @"cube";
            ca.subtype =@"fromTop";
            [btn.layer addAnimation:ca forKey:nil];
        }//        NSLog(@"%@",[self.temp lastObject]);
    }
}
-(void)btnOnclick:(UIButton *)sender{
    if (self.time == M) {
        [self complete];
    }
    if (self.time <= S) {
        NSString *s = [self.temp lastObject];
        if ((char)(sender.tag +'A')== [s characterAtIndex:0]) {
            self.right++;
            self.grade++;
            NSLog(@"right");
        }else{
            NSLog(@"wrong");
            [self.wrong addObject:self.temp];
        }
    }else{
        NSString *answer = @"" ;
        for (int i= 0; i < 5; i++) {
            if ([self.check[i] isEqualToValue:@1]){
                answer = [answer stringByAppendingString:[NSString stringWithFormat:@"%c",'A'+i]];
            }
        }
        NSLog(@"%@",answer);
        if ([answer isEqualToString:[self.temp lastObject]]) {
            self.right++;
            self.grade+=2;
            NSLog(@"right");
        }else{
            NSLog(@"wrong!");
            [self.wrong addObject:self.temp];
        }
    }
    if (self.time < M)
        [self setBtnTitle];
    [self initcheck];
}
-(void)initcheck{
    for (int i=0 ;i<5 ; i++) {
        self.check[i] = @0;
    }
}
-(void)complete{
    if (!self.wrong.count) {
        NSString *mge = [NSString stringWithFormat:@"本轮测试您获得了%d分的优异成绩。",(int)self.grade];
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"答题结束。" message:mge preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    NSString *mge = [NSString stringWithFormat:@"本轮测试您获得了%d分。是否进入错题浏览？",(int)self.grade];
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"答题结束。" message:mge preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
        [self performSegueWithIdentifier:@"examToRead" sender:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:cancel];
    [alert addAction:defaults];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    readViewController *rv = segue.destinationViewController;
    rv.tpic = [NSMutableArray arrayWithArray:self.wrong];
    rv.record = @"wrong";
}
-(void)clearSelect{
    for (int i = 0; i<5; i++) {
        QCheckBox *btn = self.btnArrayD[i];
        btn.checked = NO;
    }
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
//    self.check[checkbox.tag] = (NSNumber *)checkbox.checked;
    if (checkbox.checked) {
        self.check[checkbox.tag] =@1;
    }else
        self.check[checkbox.tag] =@0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)singleTpic{
    if (_singleTpic ==nil) {
        _singleTpic = [[NSMutableArray alloc]init];
    }
    return _singleTpic;
}
-(NSMutableArray *)doubleTpic{
    if (_doubleTpic ==nil) {
        _doubleTpic = [[NSMutableArray alloc]init];
    }
    return _doubleTpic;
}
-(NSMutableArray *)wrong{
    if (_wrong == nil) {
        _wrong = [NSMutableArray array];
    }
    return _wrong;
}
@end

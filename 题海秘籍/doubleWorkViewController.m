//
//  doubleWorkViewController.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/26.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "doubleWorkViewController.h"
#import "QCheckBox.h"
#import "MBProgressHUD+NJ.h"
#import <AudioToolbox/AudioToolbox.h>
int check[5];
#define vCount 6
static SystemSoundID V[vCount];
static SystemSoundID W;
@interface doubleWorkViewController ()
@property(nonatomic,strong)NSMutableArray *temp;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIScrollView *optionalView;
@property (assign, nonatomic) NSInteger right;
@property (assign, nonatomic) NSInteger num;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *item;
@property (assign,nonatomic) NSInteger time;
@property (strong,nonatomic) NSMutableArray *wrong;
@property (assign,nonatomic) NSInteger flag;
@property (weak, nonatomic) IBOutlet UIButton *awr;
@property (nonatomic ,assign)CGFloat myfont;
@property (nonatomic ,assign)CGFloat interval;
@property (nonatomic ,strong)NSMutableArray *btnArr;
@end


@implementation doubleWorkViewController
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
        _interval = 50;
    }
    else{
        _myfont = 15;
        _interval =50;
    }
    self.textField.font= [UIFont systemFontOfSize:_myfont];
    NSLog(@"_myfont = %f",_myfont);
}

- (IBAction)getBackBtn:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您未完成全部答题，是否保存错题并退出？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defauts = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveWrongTpic];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [alert addAction:defauts];
    [self presentViewController:alert animated:true completion:nil];
}
-(void)didVoice{
    for (int i = 0 ; i< vCount; i++) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"V_%d.wav",i]withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &V[i]);
    }
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"w.mp3" withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &W);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self didVoice];
    [self didMyFont];
    self.num = self.tpArray.count;
    [self didbtn];
    [self setTitle];

}
-(NSMutableArray *)wrong{
    if (_wrong ==nil) {
        _wrong = [[NSMutableArray alloc]initWithCapacity:self.num];
    }
    return _wrong;
}
-(void)initCheck{
    for (int i=0 ;i<5 ; i++) {
        check[i]=0;
    }
}
-(void)setTitle{
    if (!self.tpArray.count) {
        [self doneTipic];
        return;
    }
    NSInteger n = arc4random()%self.tpArray.count;
    self.temp = self.tpArray[n];
    [self.tpArray removeObjectAtIndex:n];
    CATransition *ca = [CATransition animation];
    ca.type =@"cube";
    ca.subtype =@"fromTop";
    [self.textField.layer addAnimation:ca forKey:nil];
    
    NSString *tp = [NSString stringWithString:self.temp[0]];
    NSMutableString *title = [NSMutableString stringWithString:tp];
    int m = 4-(int)tp.length/20;
    if (n>0) {
        for (int i =0; i < m ; i++) {
            [title insertString:@"\n" atIndex:0];
        }
    }
    self.textField.text = title;
    self.time++;
    [self.item setTitle:[NSString stringWithFormat:@"%zi/%zi",self.time,self.num]];
    if (self.temp.count == 6) {
        UIButton *btn =self.btnArr[4];
        btn.alpha = 0;
    }else{
        UIButton *btn =self.btnArr[4];
        btn.alpha = 1;
    }
    for (int i = 0 ; i< self.temp.count -2; i++) {
        UIButton *btn = self.btnArr[i];
        [btn setTitle:self.temp[i+1] forState:UIControlStateNormal];
        CATransition *ca = [CATransition animation];
        ca.type = @"cube";
        ca.subtype =@"fromTop";
        [btn.layer addAnimation:ca forKey:nil];
    }
//    [self.awr setTitle:[self.temp lastObject] forState:UIControlStateNormal];
    NSLog(@"%@",[self.temp lastObject]);
    [self initCheck];
    [self clearSelect];
}
-(void)didbtn{
    for (int i = 0; i < 5; i++) {
        CGFloat y = i * _interval;
        QCheckBox  *check = [[QCheckBox alloc]initWithDelegate:self];
        check.frame = CGRectMake(0, y, self.optionalView.frame.size.width, _interval);
        check.tag = i;
        check.titleLabel.font = [UIFont systemFontOfSize:_myfont];
        check.titleLabel.lineBreakMode = 0;
        [check setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [check setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        [check setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [check.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
        [check setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
        [check setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
        [self.btnArr addObject:check];
        [self.optionalView addSubview:check];
    }

}
-(NSMutableArray *)btnArr{
    if (_btnArr ==nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}

- (IBAction)btnOnClick:(id)sender {
    NSString *answer = @"" ;
    for (int i= 0; i < 5; i++) {
        if (check[i]){
            answer = [answer stringByAppendingString:[NSString stringWithFormat:@"%c",'A'+i]];
        }
    }
    NSLog(@"%@",answer);
//    NSLog(@"%@",[self.temp lastObject]);
    if ([answer isEqualToString:[self.temp lastObject]]) {
        self.right++;
        if (self.right ==1 &&self.flag == 0) {
            AudioServicesPlaySystemSound(V[0]);
        }else{
        if (!self.voice) {
            NSInteger i = arc4random() % 3 +1;
            AudioServicesPlaySystemSound(V[i]);
        }
        if (!self.shake) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        }
        if (self.record) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您答对了" message:[NSString stringWithFormat:@"是否将该题移出错题集？"]preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate deleteDWrongTpic:self wrong:self.temp];
                [self setTitle];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self setTitle];
            }];
            [alert addAction:defaults];
            [alert addAction:cancel];
            [self presentViewController:alert animated:true completion:nil];
        }else{
            [MBProgressHUD showSuccess:@"正确"];
            [self setTitle];
        }
    }else{
        if (!self.voice) {
            AudioServicesPlaySystemSound(W);
        }
        //        AudioServicesPlayAlertSound(V[4]);
        [self.wrong addObject:self.temp];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您答错了" message:[NSString stringWithFormat:@"正确答案是：%@",[self.temp lastObject]]preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self setTitle];;
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self doneTipic];
}
-(void)doneTipic{
    if (!self.tpArray.count) {
        float rate = self.right * 1.0 /self.num;
        if (!self.voice&&!self.flag) {
            AudioServicesPlaySystemSound(V[5]);
        }
        if (!self.wrong.count) {
            NSString *mge = [NSString stringWithFormat:@"本轮答题正确率为%.2f%%恭喜你已完成测试",rate * 100];
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"您已完成答题。" message:mge preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self saveWrongTpic];
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            NSString *mge = [NSString stringWithFormat:@"本轮答题正确率为%.2f%%。是否进入错题回顾？",rate * 100];
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"您已完成答题。" message:mge preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.tpArray = [self.wrong mutableCopy];
                [self saveWrongTpic];
                self.num = self.wrong.count;
                self.wrong = nil;
                self.time = 0;
                self.right = 0;
                [self setTitle];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self saveWrongTpic];
                [self.navigationController popViewControllerAnimated:true];
            }];
            [alert addAction:cancel];
            [alert addAction:defaults];
            [self presentViewController:alert animated:YES completion:nil];
        }
        return ;
    }
}

-(void)saveWrongTpic{
    if (!self.flag) {
        if ([self.delegate respondsToSelector:@selector(saveDwrongTpic:wrong:)]) {
            [self.delegate saveDwrongTpic:self wrong:self.wrong];
        }
        self.flag++;
    }
}
-(NSMutableArray *)tpArray{
    if (_tpArray == nil) {
        _tpArray = [[NSMutableArray alloc]init];
    }
    return _tpArray;
}
-(void)clearSelect{
    for (int i = 0; i<5; i++) {
        QCheckBox *btn = self.btnArr[i];
        btn.checked = NO;
    }
}
#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    check[checkbox.tag] = checkbox.checked;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

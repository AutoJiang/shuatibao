//
//  sctionSelectTable.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/17.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "sctionSelectTable.h"
#import "workViewController.h"
#import "doubleWorkViewController.h"
#import "examinationViewController.h"
#import "readViewController.h"
#import "searchViewController.h"
#define ImageCount 5

@interface sctionSelectTable ()<workViewControllerDelegate,doubleWorkViewControllerDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray *Singletopic;
@property (nonatomic,strong) NSMutableArray *Doubletopic;
@property (nonatomic,strong) NSMutableSet *SingleWrong;
@property (nonatomic,strong) NSMutableSet *DoubleWrong;
@property (nonatomic,strong) NSMutableArray *currentTpic;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *sd;
@end

@implementation sctionSelectTable

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = width / 2.0;
    self.headView.frame= CGRectMake(0, 0, width, height);
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    for (int i = 0; i < ImageCount; i++) {
        CGFloat imageX = i * width;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageX, 0,width, height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image_%d",i]];
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(ImageCount*width, height);
    self.scrollView.pagingEnabled =YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl.numberOfPages =ImageCount;
    [self.headView addSubview:self.scrollView];
    [self.headView addSubview:self.pageControl];
    [self addScrollTimer];
    
    [self openDb];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ctj",self.bookName]];
    self.SingleWrong =[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSString *pathd = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"D%@.ctj",self.bookName]];
    self.DoubleWrong =[NSKeyedUnarchiver unarchiveObjectWithFile:pathd];
    
    
}

-(void)openDb{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documents = [paths objectAtIndex:0];
//    NSString *database_path = [documents stringByAppendingPathComponent:@"tiku.db"];
    NSString *database_path = [[NSBundle mainBundle]pathForResource:@"tiku.db" ofType:nil];
//    NSLog(@"%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db)!= SQLITE_OK) {
        sqlite3_close(db);
    }else{
        NSString *quary =[NSString stringWithFormat:@"SELECT * FROM %@",self.bookName];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(db, [quary UTF8String], -1, &stmt, nil)==SQLITE_OK) {
            while (sqlite3_step(stmt)==SQLITE_ROW) {
                NSMutableArray *temp,*arr = [NSMutableArray array],*chapter;
                int pid = sqlite3_column_int(stmt, 1);
                int type= sqlite3_column_int(stmt, 3);
                if (!sqlite3_column_int(stmt, 0)) {
                    for (int i =0 ; i < pid; i++) {
                        NSMutableArray *sArr = [NSMutableArray array];
                        NSMutableArray *dArr = [NSMutableArray array];
                        [self.Singletopic addObject:sArr];
                        [self.Doubletopic addObject:dArr];
                    }
                    continue;
                }
                if (type == 1 ||type ==3) {
                    temp =self.Singletopic;
                }else if(type == 2){
                    temp =self.Doubletopic;
                }
                if([self.bookName isEqual:@"mao2"]&&pid>=7)
                    pid -=6;
                chapter = temp[pid];
                
                char *title = (char *)sqlite3_column_text(stmt, 4);
                NSString *titleString =[[NSString alloc]initWithUTF8String:title];
                [arr addObject:titleString];
                
                char *op = (char *)sqlite3_column_text(stmt, 5);
                NSString *opString =[[NSString alloc]initWithUTF8String:op];
                for (int i = 0,j = 0;i < opString.length; i++) {
                    unichar c=[opString characterAtIndex:i];
                    if ( c=='B'||c=='C'||c=='D'||c=='E'||c=='F'||i==opString.length-1) {
                        if (i == opString.length-1)
                            i++;
                        if (i!=j) {
                            NSRange range;
                            range.location = j;
                            range.length = i -j;
                            [arr addObject:[opString substringWithRange:range]];
                            j = i;
                        }
                    }
                }
                if (type ==3) {
                    [arr addObject:@"A.对"];
                    [arr addObject:@"B.错"];
                }
                
                char *answer = (char *)sqlite3_column_text(stmt, 6);
                NSString *answerString = [[NSString alloc]initWithUTF8String:answer];
                [arr addObject:answerString];
                [chapter addObject:arr];
            }
        }else{
            NSLog(@"no");
        }
    }
}



- (void)addScrollTimer
{
    self.timer = [NSTimer timerWithTimeInterval:1.5f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeScrollTimer
{
    [self.timer invalidate];
    self.timer = nil;
    
}
- (void)nextPage
{
    long currentPage = self.pageControl.currentPage;
    currentPage ++;
    if (currentPage == ImageCount) {
        currentPage = 0;
    }
    
    CGFloat width = self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(currentPage * width, 0.f);
    [UIView animateWithDuration:.2f animations:^{
        self.scrollView.contentOffset = offset;
    }];
    
}
#pragma mark - UIScrollViewDelegate实现方法-
// scrollView滚动时执行
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"scrollViewDidScroll");
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int pageNum = (offsetX + .5f *  width) / width;
    
    self.pageControl.currentPage = pageNum;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging");
    [self addScrollTimer];
}

-(NSArray *)Singletopic{
    if (_Singletopic == nil) {
//        NSString *path = [[NSBundle mainBundle]pathForResource:self.bookName ofType:@"plist"];
        _Singletopic = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _Singletopic;
}
-(NSMutableArray *)Doubletopic{
    if (_Doubletopic == nil) {
//        NSString *name = [NSString stringWithFormat:@"D%@",self.bookName];
//        NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"plist"];
        _Doubletopic = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return _Doubletopic;
}
-(NSMutableSet *)SingleWrong{
    if (_SingleWrong ==nil) {
        _SingleWrong = [[NSMutableSet alloc]init];
    }
    return _SingleWrong;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.Singletopic count];
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return [self.Singletopic count];
    }
    else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sctionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"sctionCell"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row +1];
        cell.imageView.image = [UIImage imageNamed:@"cell_0"];
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"错题集"];
        cell.imageView.image = [UIImage imageNamed:@"cell_1"];
    }
    if(indexPath.section == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld章",indexPath.row +1];
        cell.imageView.image = [UIImage imageNamed:@"cell_2"];
    }
    if (indexPath.section ==3) {
        cell.textLabel.text = [NSString stringWithFormat:@"模拟考场"];
        cell.imageView.image = [UIImage imageNamed:@"cell_3"];
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"题库浏览";
    }
    if (section == 2) {
        return @"章节练习";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择题库的类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.currentTpic = self.Singletopic;
            self.sd = @"S";
            [self performSegueWithIdentifier:@"selectToRead" sender:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.currentTpic = self.Doubletopic;
            self.sd = @"D";
            [self performSegueWithIdentifier:@"selectToRead" sender:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];

    }
    if (indexPath.section == 1||indexPath.section == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择答题的类型" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"单选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (indexPath.section == 1 && !self.SingleWrong.count) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"错题集暂无错题！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alert2 addAction:action];
                [self presentViewController:alert2 animated:true completion:nil];
            }
            [self performSegueWithIdentifier:@"selectTowork" sender:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"多选" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (indexPath.section == 1 && !self.DoubleWrong.count) {
                UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"错题集暂无错题！" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert2 addAction:action];
                [self presentViewController:alert2 animated:true completion:nil];
            }
            [self performSegueWithIdentifier:@"selectToDwork" sender:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
    }
    else if(indexPath.section == 3){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您将在20分钟内完成60道单选和20道多选，是否要进入？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaults = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self performSegueWithIdentifier:@"selectToExam" sender:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:defaults];
        [alert addAction:cancel];
        [self presentViewController:alert animated:true completion:nil];
        
    }
}
#pragma workViewController delegate
-(void)saveWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray{
    if (self.SingleWrong ==nil) {
        self.SingleWrong =[[NSMutableSet alloc]initWithArray:WrongArray];
    }else{
        [self.SingleWrong addObjectsFromArray:WrongArray];
    }
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ctj",self.bookName]];
    NSLog(@"%@",path);
    [NSKeyedArchiver archiveRootObject:self.SingleWrong toFile:path];
}
-(void)deleteWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray{
    if (WrongArray !=nil) {
        [self.SingleWrong removeObject:WrongArray];
    }
}
#pragma doubleViewController delegate

-(void)saveDwrongTpic:(doubleWorkViewController *)dworkView wrong:(NSMutableArray *)WrongArray{
    if (self.DoubleWrong ==nil) {
        self.DoubleWrong =[[NSMutableSet alloc]initWithArray:WrongArray];
    }else{
        [self.DoubleWrong addObjectsFromArray:WrongArray];
    }
    NSString *pathd = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"D%@.ctj",self.bookName]];
    [NSKeyedArchiver archiveRootObject:self.DoubleWrong toFile:pathd];
}
-(void)deleteDWrongTpic:(doubleWorkViewController *)dworkView wrong:(NSMutableArray *)WrongArray{
    if (WrongArray !=nil) {
        [self.DoubleWrong removeObject:WrongArray];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[workViewController class]]) {
        workViewController *wc = segue.destinationViewController;
        wc.record = NO;
        wc.voice = self.voice;
        wc.shake = self.shake;
        NSIndexPath * indexpath = [self.tableView indexPathForSelectedRow];
        if (indexpath.section == 1) {               //进入错题集
            for (NSMutableArray *oj in self.SingleWrong) {
                wc.record = YES;
                [wc.tpArray addObject:oj];
            }
        }else if(indexpath.section ==2){
            wc.tpArray = [[NSMutableArray alloc]initWithArray:self.Singletopic[indexpath.row]];
        }
        wc.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[doubleWorkViewController class]]) {
        doubleWorkViewController *dw = segue.destinationViewController;
        dw.voice = self.voice;
        dw.shake = self.shake;
        NSIndexPath * indexpath = [self.tableView indexPathForSelectedRow];
        if (indexpath.section == 1) {
            for (NSMutableArray *oj in self.DoubleWrong) {
                [dw.tpArray addObject:oj];
            }
        }else if(indexpath.section == 2){
            dw.tpArray = [[NSMutableArray alloc]initWithArray:self.Doubletopic[indexpath.row]];
        }
        dw.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[examinationViewController class]]){
        examinationViewController *ev = segue.destinationViewController;
        for (NSMutableArray *ar in self.Singletopic) {
            [ev.singleTpic addObjectsFromArray:ar];
        }
        for (NSMutableArray *ar in self.Doubletopic) {
            [ev.doubleTpic addObjectsFromArray:ar];
        }
    }
    else if([segue.destinationViewController isKindOfClass:[readViewController class]]){
        readViewController *rd =segue.destinationViewController;
        NSIndexPath * indexpath = [self.tableView indexPathForSelectedRow];
        rd.tpic = [NSMutableArray arrayWithArray:self.currentTpic[indexpath.row]];
        rd.record = [self.bookName stringByAppendingString:[NSString stringWithFormat:@"_%@_%ld",self.sd,(long)indexpath.row]];
        NSLog(@"%@",rd.record);
    }
    else if([segue.destinationViewController isKindOfClass:[searchViewController class]]){
        searchViewController *sv =segue.destinationViewController;
        for (int i = 0; i<self.Singletopic.count; i++) {
            NSMutableArray *temp = self.Singletopic[i];
            if (sv.allArray ==nil) {
                sv.allArray = [NSMutableArray arrayWithArray:temp];
            }else{
                [sv.allArray addObjectsFromArray:temp];
            }
        }
        for (int i = 0; i<self.Doubletopic.count; i++) {
            NSMutableArray *temp = self.Doubletopic[i];
            [sv.allArray addObjectsFromArray:temp];
        }
    }
}

@end

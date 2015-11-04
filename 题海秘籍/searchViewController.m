//
//  searchViewController.m
//  刷题宝
//
//  Created by jiang aoteng on 15/11/1.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "searchViewController.h"
#import "readViewController.h"

@interface searchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchResultsUpdating>
@property (nonatomic,strong) NSMutableArray *filterArray;
@property (strong,nonatomic) NSArray *temp;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)UISearchController *searchController;
@property (strong,nonatomic)NSMutableArray *changeArray;

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0 ; i < self.allArray.count; i++) {
        NSMutableArray *temp =self.allArray[i];
        NSString *content = [NSString stringWithString:temp[0]];
        for (int j = 1; j < temp.count; j++) {
            content = [content stringByAppendingString:@"\n"];
            content = [content stringByAppendingString:temp[j]];
        }
        [self.changeArray addObject:content];
    }
//    self.temp = self.allArray[0];
//    self.temp = self.temp[0];
//    NSLog(@"temp= %@",self.temp[0]);
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
}
- (IBAction)getBackBtn:(id)sender {
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:true];
}

-(NSMutableArray *)changeArray{
    if (_changeArray == nil) {
        _changeArray = [NSMutableArray array];
    }
    return _changeArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.filterArray count];
    }else{
        return [self.changeArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (self.searchController.active) {
        [cell.textLabel setText:self.filterArray[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.changeArray[indexPath.row]];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.active) {
        NSString *tp = self.filterArray[indexPath.row];
        self.temp = [tp componentsSeparatedByString:@"\n"];
    }else{
        NSString *tp = self.changeArray[indexPath.row];
        self.temp = [tp componentsSeparatedByString:@"\n"];
    }
    self.searchController.active = NO;
//    [self.searchController resignFirstResponder];
    [self performSegueWithIdentifier:@"searchToRead" sender:nil];
    
}

#pragma mark - searchdelegate
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.filterArray!= nil) {
        [self.filterArray removeAllObjects];
    }
    //过滤数据
    self.filterArray= [NSMutableArray arrayWithArray:[self.changeArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[readViewController class]]) {
        readViewController *rv = segue.destinationViewController;
        [rv.tpic addObject:self.temp];
        rv.record = @"wrong";
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat X = 320+indexPath.row*50;
    cell.frame = CGRectMake(X, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView animateWithDuration:0.7 animations:^{
        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}
@end

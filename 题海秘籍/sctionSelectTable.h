//
//  sctionSelectTable.h
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/17.
//  Copyright (c) 2015年 Auto. All rights reserved.
//.

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface sctionSelectTable : UITableViewController{
    sqlite3 *db;
}
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSString *bookName;
@property (nonatomic ,assign) BOOL voice;
@property (nonatomic ,assign) BOOL shake;
@end

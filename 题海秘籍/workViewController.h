//
//  workViewController.h
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/22.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class workViewController;

@protocol workViewControllerDelegate <NSObject>

-(void)saveWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray;
-(void)deleteWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray;
@end

@interface workViewController : UIViewController

@property (nonatomic ,strong) NSMutableArray *tpArray;
@property (nonatomic ,assign) BOOL record;

@property (nonatomic ,assign) BOOL voice;
@property (nonatomic ,assign) BOOL shake;

@property(nonatomic,strong)id<workViewControllerDelegate>delegate;

@end

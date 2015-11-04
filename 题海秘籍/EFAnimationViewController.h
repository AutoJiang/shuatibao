//
//  EFAnimationViewController.h
//  aaatest
//
//  Created by jiang aoteng on 15/9/10.
//  Copyright (c) 2015年 Auto. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface EFAnimationViewController : UIViewController

@end

@protocol EFItemViewDelegate <NSObject>

- (void)didTapped:(NSInteger)index;

@end




@interface EFItemView : UIButton

@property (nonatomic, weak) id <EFItemViewDelegate>delegate;

- (instancetype)initWithNormalImage:(NSString *)normal highlightedImage:(NSString *)highlighted tag:(NSInteger)tag title:(NSString *)title;

@end
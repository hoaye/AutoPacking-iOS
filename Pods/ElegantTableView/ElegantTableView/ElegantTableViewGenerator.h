//
//  ElegantTableViewGenerator.h
//  ElegantTableViewDemo
//
//  Created by YJHou on 2017/7/3.
//  Copyright © 2017年 houmanager. All rights reserved.
//  优雅的 创建简单的 TableView

/** 当前版本: 0.0.3 */

#import <UIKit/UIKit.h>

typedef void(^didSelectRowHandleBlock)(UITableView *tableView, NSIndexPath *indexPath);
typedef void(^didScrollHandleBlock)(UIScrollView *tableView, CGPoint contentOffset);

@interface ElegantTableViewGenerator : NSObject

/** 单例 */
+ (ElegantTableViewGenerator *)shareInstance;

/** 创建tableView */
- (UITableView *)createWithFrame:(CGRect)frame
                          titles:(NSArray *)titles
                       subTitles:(NSArray *)subTitles
                       rowHeight:(CGFloat)rowHeight
               didSelectRowBlock:(didSelectRowHandleBlock)didSelectRowBlock
                  didScrollBlock:(didScrollHandleBlock)didScrollBlock;

@end

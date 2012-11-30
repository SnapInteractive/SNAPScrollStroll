//
//  SNAPViewController.h
//  scroll-stroll-demo
//
//  Created by Edwin Iskandar on 11/30/12.
//  Copyright (c) 2012 Snap-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SNAPScrollStroll;

@interface SNAPViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SNAPScrollStroll *scrollStroll;
@end

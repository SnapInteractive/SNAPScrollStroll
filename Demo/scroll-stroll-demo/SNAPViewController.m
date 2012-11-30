//
//  SNAPViewController.m
//  scroll-stroll-demo
//
//  Created by Edwin Iskandar on 11/30/12.
//  Copyright (c) 2012 Snap-Interactive. All rights reserved.
//

#import "SNAPViewController.h"
#import "SNAPScrollStroll.h"

@interface SNAPViewController ()
@end

@implementation SNAPViewController
const CGFloat scrollStrollWidth = 100.0f;
const CGFloat scrollStrollHeight = 30.0f;

- (void)viewDidLoad
{
    [super viewDidLoad];	
	
	// initialize the scroll stroll view and add it to this view
	self.scrollStroll = [[SNAPScrollStroll alloc] initWithAnimationImageNames:@[@"snap_walking_char1", @"snap_walking_char2", @"snap_walking_char3", @"snap_walking_char4", @"snap_walking_char5", @"snap_walking_char6", @"snap_walking_char7", @"snap_walking_char8"]];
	
	// position it to the right of the table
	self.scrollStroll.frame = CGRectOffset(self.scrollStroll.frame, self.tableView.frame.size.width - self.scrollStroll.frame.size.width, 0.0f);
	[self.view addSubview:self.scrollStroll];
}


#pragma mark UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
    cell.textLabel.text = [NSString stringWithFormat:@"ROW %i", indexPath.row];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"You are looking at row %i", indexPath.row];
    
	// update the scrollStroll with text
	self.scrollStroll.textLabel.text = [NSString stringWithFormat:@"R%i", indexPath.row];
    return cell;
}

#pragma mark UIScrollViewDelegate methods 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	// tell scroll stroll that the view just scrolled
	[self.scrollStroll scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
	// tell scroll stroll that the view is decelerating
	[self.scrollStroll scrollViewDidEndDecelerating:scrollView];
}

@end

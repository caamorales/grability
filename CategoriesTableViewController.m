//
//  CategoriesTableViewController.m
//  Grability
//
//  Created by Camilo Morales on 14/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "Model.h"
#import "CategoryTableViewCell.h"

@interface CategoriesTableViewController ()

@end

@implementation CategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Model sharedModel].availableCategories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryTableViewCell *cell = (CategoryTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    
    cell.categoryLabel.text = [Model sharedModel].availableCategories[indexPath.row];
    cell.icon.image = [UIImage imageNamed:[Model sharedModel].availableCategories[indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    [[Model sharedModel] filterEntriesWithCategory:[Model sharedModel].availableCategories[indexPath.row]];
    [self performSegueWithIdentifier:@"toAppList" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
 
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *) view;
    
    CGRect frame = footer.contentView.frame;
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame];
    lbl.text = @"Categorías";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:27 weight:UIFontWeightLight];
    [footer addSubview:lbl];
    lbl.backgroundColor = [UIColor whiteColor];
    footer.contentView.backgroundColor = [UIColor whiteColor];
}

@end

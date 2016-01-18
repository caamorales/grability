//
//  AppListViewController.m
//  Grability
//
//  Created by Camilo Morales on 14/1/16.
//  Copyright © 2016 Camilo Morales. All rights reserved.
//

#import "AppListViewController.h"
#import "Model.h"
#import "AppTableViewCell.h"
#import "AppDetailViewController.h"

@interface AppListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation AppListViewController{
    NSIndexPath *currentIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [[Model sharedModel].filteredEntries firstObject].category;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
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
    return [Model sharedModel].filteredEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppTableViewCell *cell = (AppTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"AppCell" forIndexPath:indexPath];
    cell.titleLabel.text = [Model sharedModel].filteredEntries[indexPath.row].title;
    cell.summaryLabel.text = [Model sharedModel].filteredEntries[indexPath.row].summary;
    cell.appID = [Model sharedModel].filteredEntries[indexPath.row].idNumber;
    cell.icon.image = [UIImage imageNamed:@"AppPlaceholder"];
    cell.icon.layer.cornerRadius = 8;
    cell.icon.layer.masksToBounds = true;
    [cell downloadAppImageWithURL:[Model sharedModel].filteredEntries[indexPath.row].iconURL];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    currentIndexPath = indexPath;
    [self performSegueWithIdentifier:@"toAppDetail" sender:self];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[AppDetailViewController class]]) {
        AppDetailViewController  *dvc = (AppDetailViewController *) segue.destinationViewController;
        dvc.appEntry = [Model sharedModel].filteredEntries[currentIndexPath.row];
    }

}

@end

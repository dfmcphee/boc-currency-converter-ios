//
//  FromTableViewController.m
//  convertr
//
//  Created by Dominic McPhee on 2012-11-03.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import "FromTableViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface FromTableViewController ()

@end

@implementation FromTableViewController

@synthesize rates;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rates = ((AppDelegate *)[UIApplication sharedApplication].delegate).rates;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rowCount = [self.rates count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"label"];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom = indexPath.row;
    
    ViewController *parent = (ViewController*)[self presentingViewController];
    
    parent.from.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"label"];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

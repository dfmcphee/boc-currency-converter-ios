//
//  FromTableViewController.m
//  convertr
//
//  Created by Dominic McPhee on 2012-11-03.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import "FromTableViewController.h"
#import "ConverterViewController.h"
#import "AppDelegate.h"


@interface FromTableViewController ()

@end

@implementation FromTableViewController

@synthesize rates;
@synthesize searchResults;

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *results = [NSMutableArray array];
    for (NSDictionary* rate in rates) {
        NSString *label = [rate objectForKey:@"label"];
        NSRange range = [label rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            [results addObject:rate];
        }
    }
    searchResults = results;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor darkGrayColor];
    
    [self filterContentForSearchText:searchString
        scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
            objectAtIndex:[self.searchDisplayController.searchBar
                selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    
    else {
        return [rates count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *currencyIdentifier = @"Currency";
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:currencyIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:currencyIdentifier];
    }
    
    NSString *shortcode;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if ([language isEqualToString:@"fr"]) {
            cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"labelFR"];
        }
        else {
            cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"label"];
        }
        shortcode = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"shortcode"];
    }
    
    else {
        if ([language isEqualToString:@"fr"]) {
            cell.textLabel.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"labelFR"];
        }
        else {
            cell.textLabel.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"label"];
        }
        shortcode = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"shortcode"];
    }
    
    NSString *flag = [@[shortcode, @".png"] componentsJoinedByString:@""];
    
    cell.imageView.image = [UIImage imageNamed:flag];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger selected = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:(selected) inSection:0];
    //NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(selected + 5) inSection:0];
    //[[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [[self tableView] selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rates = ((AppDelegate *)[UIApplication sharedApplication].delegate).rates;
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor darkGrayColor];
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ConverterViewController *parent = (ConverterViewController*)[self presentingViewController];
    NSString *shortcode;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([self.searchDisplayController isActive]) {
        if ([language isEqualToString:@"fr"]) {
            parent.from.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"labelFR"];
        }
        else {
            parent.from.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"label"];
        }
        
        shortcode = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"shortcode"];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom = [rates indexOfObject:[searchResults objectAtIndex:indexPath.row]];
    }
    
    else {
        if ([language isEqualToString:@"fr"]) {
            parent.from.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"labelFR"];
        }
        else {
            parent.from.text = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"label"];
        }
        shortcode = [[self.rates objectAtIndex:indexPath.row] objectForKey:@"shortcode"];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom = indexPath.row;
    }
    
    NSString *flag = [@[shortcode, @".png"] componentsJoinedByString:@""];
    
    parent.fromFlag.image = [UIImage imageNamed:flag];
    
    [parent convert:parent];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

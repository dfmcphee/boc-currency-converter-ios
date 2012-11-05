//
//  FromTableViewController.h
//  convertr
//
//  Created by Dominic McPhee on 2012-11-03.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FromTableViewController : UITableViewController {
    NSArray *rates;
}

@property (retain, nonatomic) IBOutlet NSArray *rates;

@end

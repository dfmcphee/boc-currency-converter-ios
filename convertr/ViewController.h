//
//  ViewController.h
//  convertr
//
//  Created by Dominic McPhee on 2012-11-02.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    UIActionSheet *fromSheet;
    UIActionSheet *toSheet;
    
    NSArray *rates;
    
    IBOutlet UITextField *amount;
    IBOutlet UILabel *from;
    IBOutlet UILabel *to;
    IBOutlet UILabel *answer;
}

@property (retain, nonatomic) IBOutlet UITextField *amount;
@property (retain, nonatomic) IBOutlet UILabel *from;
@property (retain, nonatomic) IBOutlet UILabel *to;
@property (retain, nonatomic) IBOutlet UILabel *answer;
@property (retain, nonatomic) IBOutlet NSArray *rates;

- (IBAction)convert:(id)sender;

- (IBAction)amountReturn:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

@end
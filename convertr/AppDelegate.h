//
//  AppDelegate.h
//  convertr
//
//  Created by Dominic McPhee on 2012-11-02.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSArray *rates;
    NSInteger *selectedTo;
    NSInteger *selectedFrom;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IBOutlet NSArray *rates;
@property (nonatomic) NSInteger selectedTo;
@property (nonatomic) NSInteger selectedFrom;

@end

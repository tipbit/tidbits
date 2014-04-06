//
//  BlockButton.h
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockButton : NSObject

+(instancetype)button;
+(instancetype)label:(NSString *)label;
+(instancetype)label:(NSString *)label action:(void(^)())action;
+(instancetype)label:(NSString *)label actionWithText:(void(^)(NSString *text))action;
+(instancetype)label:(NSString *)label actionWithTextText:(void(^)(NSString *username, NSString *password))action;

@property (nonatomic, strong) NSString *label;
@property (nonatomic, copy) void(^action)();
@property (nonatomic, copy) void(^actionWithText)(NSString *text);
@property (nonatomic, copy) void(^actionWithTextText)(NSString *username, NSString *password);

@property (nonatomic, assign) int tag;
@property (nonatomic, weak) UIView *parentView;

//simply there for migration from TBMenuItem
+(instancetype)header:(NSString *)headerTitle;

@property (nonatomic) BOOL isHeader;

@end

/**
 * Convenience functions for creating BlockButtons with labels and associated actions.
 * These methods are shorthand for BlockButton:label:action, BlockButton:label:actionWithText, and BlockButton:label:actionWithTextText
 * @param label  This is the label that is displayed on the UIAlertView / UIActionSheet button.
 @ @param action This is the block of code that is executed when the UIAlertView / UIActionSheet button is pressed.
 * @discussion  Thre are three variants of the action block.  
 * The first is a void block.  This is the most commonly used.
 * The second is a block that has a single String argument.  The argument returned is the block label.
 * The third is outputs two string argumetns -- this is used for the UIAlertView that accepts username / password.
 */

BlockButton *button(NSString *label, void(^action)());
BlockButton *buttonT(NSString *label, void(^action)(NSString *label));
BlockButton *buttonTT(NSString *label, void(^action)(NSString *username, NSString *password));

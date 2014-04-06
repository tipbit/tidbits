//
//  BlockButton.m
//  Tipbit
//
//  Created by Navi Singh on 3/29/14.
//  Copyright (c) 2014 Tipbit. All rights reserved.
//

#import "BlockButton.h"

@implementation BlockButton

+(instancetype)button
{
    BlockButton *button =[self new];
    button.tag = 0;
    return button;
}

+(instancetype)header:(NSString *)headerTitle
{
    BlockButton *button = [self button];
    button.label = headerTitle;
    button.isHeader = YES;
    return button;
}

+(instancetype)label:(NSString *)label
{
    return [BlockButton label:label action:nil];
}

+(instancetype)label:(NSString *)label action:(void(^)())action
{
    BlockButton *button = [self button];
    button.label = label;
    button.action = action;
    return button;
}

+(instancetype)label:(NSString *)label actionWithText:(void(^)(NSString *))action
{
    BlockButton *button = [self button];
    button.label = label;
    button.actionWithText = action;
    return button;
}

+(instancetype)label:(NSString *)label actionWithTextText:(void(^)(NSString *, NSString *))action
{
    BlockButton *button = [self button];
    button.label = label;
    button.actionWithTextText = action;
    return button;
}

- (NSString *)description
{
	return [[super description] stringByAppendingFormat:@"  Label: %@", self.label];
}

@end

BlockButton *button(NSString *label, void(^action)())
{
    BlockButton *button = [BlockButton label:label action:action];
    return button;
}
BlockButton *buttonT(NSString *label, void(^action)(NSString *))
{
    BlockButton *button = [BlockButton label:label actionWithText:action];
    return button;
}
BlockButton *buttonTT(NSString *label, void(^action)(NSString *, NSString *))
{
    BlockButton *button = [BlockButton label:label actionWithTextText:action];
    return button;
}

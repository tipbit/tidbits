//
//  UITableViewCell+Misc.h
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewCell (Misc)


/**
 * Equivalent to NSStringFromClass([self class]);
 */
+(NSString *)tb_cellIdentifier;

/**
 * Equivalent to [self tb_registerNibOnTableView:tableView forCellReuseIdentifier:[self tb_cellIdentifier])].
 */
+(void)tb_registerNibOnTableView:(UITableView *)tableView;

/**
 * Get the nib that's named the same as the current class, and register that using the given cell identifier.
 *
 * Obviously this only makes sense when called on a subclass of UITableViewCell.
 */
+(void)tb_registerNibOnTableView:(UITableView *)tableView forCellReuseIdentifier:(NSString *)identifier;


/**
 * Equivalent to [tableView dequeueReusableCellWithIdentifier:[self tb_cellIdentifier] forIndexPath:indexPath].
 */
+(instancetype)tb_dequeueCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic) NSString * tb_key;


@end

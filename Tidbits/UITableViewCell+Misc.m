//
//  UITableViewCell+Misc.m
//  Tidbits
//
//  Created by Ewan Mellor on 8/7/15.
//  Copyright (c) 2015 Tipbit, Inc. All rights reserved.
//

#import "SynthesizeAssociatedObject.h"

#import "UITableViewCell+Misc.h"


@implementation UITableViewCell (Misc)


+(NSString *)tb_cellIdentifier {
    return NSStringFromClass([self class]);
}


+(void)tb_registerNibOnTableView:(UITableView *)tableView {
    [self tb_registerNibOnTableView:tableView forCellReuseIdentifier:[self tb_cellIdentifier]];
}


+(void)tb_registerNibOnTableView:(UITableView *)tableView forCellReuseIdentifier:(NSString *)identifier {
    NSString * classname = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
}


+(instancetype)tb_dequeueCellFromTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[self tb_cellIdentifier] forIndexPath:indexPath];
}


SYNTHESIZE_ASSOCIATED_OBJ(NSString *, tb_key, setTb_key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);


@end

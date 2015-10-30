//
//  MQChatViewTableDataSource.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewTableDataSource.h"
#import "MQChatBaseCell.h"
#import "MQCellModelProtocol.h"


@implementation MQChatViewTableDataSource {
    UITableView *chatTableView;
    MQChatViewModel *chatViewModel;
}

- (instancetype)initWithTableView:(UITableView *)tableView chatViewModel:(MQChatViewModel *)viewModel {
    if (self = [super init]) {
        chatTableView = tableView;
        chatViewModel = viewModel;
    }
    return self;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [chatViewModel.cellModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MQCellModelProtocol> cellModel = [chatViewModel.cellModels objectAtIndex:indexPath.row];
    NSString *cellModelName = NSStringFromClass([cellModel class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModelName];
    if (cell == nil){
        cell = [cellModel getCellWithReuseIdentifier:cellModelName];
    }
    if (![cell isKindOfClass:[MQChatBaseCell class]]) {
        NSAssert(NO, @"ChatTableDataSource的cellForRow中，没有返回正确的cell类型");
        return cell;
    }
    [(MQChatBaseCell*)cell updateCellWithCellModel:cellModel];
    return cell;
}


@end

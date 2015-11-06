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

@interface MQChatViewTableDataSource()

@property (nonatomic, weak) UITableView *chatTableView;
@property (nonatomic, weak) MQChatViewService *chatViewModel;


@end

@implementation MQChatViewTableDataSource {
}

- (instancetype)initWithTableView:(UITableView *)tableView chatViewModel:(MQChatViewService *)viewModel {
    if (self = [super init]) {
        self.chatTableView = tableView;
        self.chatViewModel = viewModel;
    }
    return self;
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.chatViewModel.cellModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MQCellModelProtocol> cellModel = [self.chatViewModel.cellModels objectAtIndex:indexPath.row];
    NSString *cellModelName = NSStringFromClass([cellModel class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellModelName];
    if (!cell){
//        if (!(cell = [tableView cellForRowAtIndexPath:indexPath])) {
            cell = [cellModel getCellWithReuseIdentifier:cellModelName];
            MQChatBaseCell *chatCell = (MQChatBaseCell*)cell;
            chatCell.chatCellDelegate = self.chatCellDelegate;
//        }
    }
    if (![cell isKindOfClass:[MQChatBaseCell class]]) {
        NSAssert(NO, @"ChatTableDataSource的cellForRow中，没有返回正确的cell类型");
        return cell;
    }
    [(MQChatBaseCell*)cell updateCellWithCellModel:cellModel];
    return cell;
}




@end

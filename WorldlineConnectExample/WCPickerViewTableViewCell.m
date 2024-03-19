//
//  WCPickerViewTableViewCell.m
//  WorldlineConnectExample
//
//  Created for Worldline Global Collect on 15/12/2016.
//  Copyright © 2017 Worldline Global Collect. All rights reserved.
//

#import <WorldlineConnectExample/WCPickerViewTableViewCell.h>

@interface WCPickerViewTableViewCell ()

@property (strong, nonatomic) WCPickerView *pickerView;

@end

@implementation WCPickerViewTableViewCell
+(NSUInteger)pickerHeight {
    return 216;
}
+ (NSString *)reuseIdentifier {
    return @"picker-view-cell";
}
-(void)setReadonly:(BOOL)readonly {
    self->_readonly = readonly;
    self->_pickerView.userInteractionEnabled = !readonly;
    self->_pickerView.alpha = readonly ? 0.6f : 1.0f;
}
-(BOOL)readonly {
    return self->_readonly;
}
- (void)setItems:(NSArray<WCValueMappingItem *> *)items {
    _items = items;
    if (items != nil) {
        NSMutableArray *names = [[NSMutableArray alloc]initWithCapacity:items.count];
        for (WCValueMappingItem *item in items) {
            [names addObject:item.displayName];
        }
        self.pickerView.content = names;
    }
}

- (NSObject<UIPickerViewDelegate> *)delegate {
    return self.pickerView.delegate;
}

- (void)setDelegate:(NSObject<UIPickerViewDelegate> *)delegate {
    self.pickerView.delegate = delegate;
}

- (NSObject<UIPickerViewDataSource> *)dataSource {
    return self.pickerView.dataSource;
}

- (void)setDataSource:(NSObject<UIPickerViewDataSource> *)dataSource {
    self.pickerView.dataSource = dataSource;
}

- (NSInteger)selectedRow {
    return [self.pickerView selectedRowInComponent:0];
}

- (void)setSelectedRow:(NSInteger)selectedRow {
    [self.pickerView selectRow:selectedRow inComponent:0 animated:false];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.pickerView = [WCPickerView new];
    
    [self addSubview:self.pickerView];
    
    self.clipsToBounds = YES;
    
    return self;
}
- (CGFloat)pickerLeftMarginForFitSize:(CGSize)fitsize {
    if (self.accessoryType != UITableViewCellAccessoryNone) {
        if (self.contentView.frame.size.width > CGRectGetMidX(self.frame) - fitsize.width/2 + fitsize.width)
        {
            return CGRectGetMidX(self.frame) - fitsize.width/2;
        }
        else {
            return 16;
        }
    }
    else {
        if(self.contentView.frame.size.width > CGRectGetMidX(self.frame) - fitsize.width/2 + fitsize.width + 16 + 22 + 16) {
            return CGRectGetMidX(self.frame) - fitsize.width/2;
        }
        else {
            return 16;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.pickerView != nil) {
        CGFloat width = self.contentView.frame.size.width;
        CGFloat height =  [WCPickerViewTableViewCell pickerHeight];
        CGRect frame = CGRectMake(10, 0, width - 20,height);
        frame.size = [self.pickerView sizeThatFits:frame.size];
        frame.origin.x = width/2 - frame.size.width/2;
        self.pickerView.frame = frame;
    }
}

- (void)prepareForReuse {
    self.items = [[NSArray alloc] init];
    self.delegate = nil;
    self.dataSource = nil;
}

@end

//
//  RBCameraCell.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBCameraCell.h"
#import "UIColor+SohoXiColor.h"

#define STATUS_IMAGE_SIZE       30

@interface RBCameraCell ()
@property (nonatomic, strong) UIImageView   *statusImageView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *addressLabel;
@end

@implementation RBCameraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statusImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:imageView];
            
            NSDictionary *viewDict = @{@"imageView":imageView};
            NSDictionary *metrics = @{@"size":@(STATUS_IMAGE_SIZE)};
            NSArray *hCN = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(size)]-(20)-|" options:0 metrics:metrics views:viewDict];
            [self.contentView addConstraints:hCN];
            
            NSLayoutConstraint *centerYCN = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
            [self.contentView addConstraint:centerYCN];
            
            imageView;
        });
        
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor graphiteColorForTheme:SOHOXIThemeDark];
            label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];
            
            NSDictionary *viewDict = @{@"label":label, @"imageView":_statusImageView};
            NSArray *hCN = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[label]-(10)-(imageView)" options:0 metrics:nil views:viewDict];
            [self.contentView addConstraints:hCN];
            
            NSArray *vCN = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[label]" options:0 metrics:nil views:viewDict];
            [self.contentView addConstraints:vCN];
            
            label;
        });
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCamera:(RBCamera *)camera {
    _camera = camera;
    
    self.titleLabel.text = camera.name;
}

@end

//
//  RBCameraCell.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/13/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBCameraCell.h"

@implementation RBCameraCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
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
    
    self.textLabel.text = camera.name;
}

@end

//
//  MyMoodDataItem.h
//  MoodTracker
//
//  Created by Barry A. Langdon-Lassagne on 9/29/12.
//  Copyright (c) 2012 Barry A. Langdon-Lassagne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MlMoodDataItem : NSObject

@property (strong, nonatomic) NSString *mood;
@property (strong, nonatomic) NSString *category;
@property (nonatomic, assign) BOOL selected;

@end

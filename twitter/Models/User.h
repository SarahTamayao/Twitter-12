//
//  User.h
//  twitter
//
//  Created by Sanjana Meduri on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profilePicture;
@property (nonatomic, strong) NSString *idString;
@property (nonatomic, strong) NSMutableArray *followers;

//initializer -- populates fields based on dictiionary version of tweet
- (instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

//
//  JsonLD.m
//  Tests
//
//  Created by Artur Protska on 09.07.2022.
//  Copyright © 2022 EasyMapping. All rights reserved.
//

#import "JsonLD.h"

@implementation JsonLD

+ (EKObjectMapping *)objectMapping {
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping * _Nonnull mapping) {
        [mapping mapKeyPath:@"@context" toProperty:@"context"];
        [mapping mapKeyPath:@"@type" toProperty:@"type"];
    }];
}

@end

//
//  JsonLD.h
//  Tests
//
//  Created by Artur Protska on 09.07.2022.
//  Copyright © 2022 EasyMapping. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <EasyMapping/EasyMapping.h>

@interface JsonLD : EKObjectModel

@property (nonatomic, strong) NSString * context;
@property (nonatomic, strong) NSString * type;

@end

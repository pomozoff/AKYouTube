//
//  EKManagedObjectMapping.m
//  EasyMappingExample
//
//  Created by Alejandro Isaza on 2013-03-13.
//  Copyright (c) 2013 Alejandro Isaza. All rights reserved.
//

#import "EKManagedObjectMapping.h"
#import "EKFieldMapping.h"

@implementation EKManagedObjectMapping

@synthesize fieldMappings = _fieldMappings;
@synthesize hasManyMappings = _hasManyMappings;
@synthesize hasOneMappings = _hasOneMappings;
@synthesize rootPath = _rootPath;

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withBlock:(void(^)(EKManagedObjectMapping *mapping))mappingBlock
{
    EKManagedObjectMapping *mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName];
    mappingBlock(mapping);
    return mapping;
}

+ (EKManagedObjectMapping *)mappingForEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath withBlock:(void (^)(EKManagedObjectMapping *mapping))mappingBlock
{
    EKManagedObjectMapping *mapping = [[EKManagedObjectMapping alloc] initWithEntityName:entityName withRootPath:rootPath];
    mappingBlock(mapping);
    return mapping;
}

- (id)initWithEntityName:(NSString *)entityName
{
    self = [super init];
    if (self) {
        _entityName = entityName;
        _fieldMappings = [NSMutableDictionary dictionary];
        _hasOneMappings = [NSMutableDictionary dictionary];
        _hasManyMappings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithEntityName:(NSString *)entityName withRootPath:(NSString *)rootPath
{
    self = [self initWithEntityName:entityName];
    if (self) {
        _rootPath = rootPath;
    }
    return self;
}

@end

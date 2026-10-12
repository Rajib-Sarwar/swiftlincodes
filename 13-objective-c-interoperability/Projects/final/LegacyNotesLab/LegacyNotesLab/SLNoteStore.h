#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
FOUNDATION_EXPORT NSString * const SLNoteErrorDomain;
typedef NS_ENUM(NSInteger, SLNoteKind) {
    SLNoteKindPlain = 0,
    SLNoteKindPinned = 1
};
@interface SLNote : NSObject
@property(nonatomic, copy, readonly) NSString *identifier;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy, nullable) NSString *body;
@property(nonatomic) SLNoteKind kind;
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title
                              body:(nullable NSString *)body kind:(SLNoteKind)kind;
- (instancetype)init NS_UNAVAILABLE;
@end
// Synchronous in-memory fixture. All accesses must be serialized by its owner.
@interface SLNoteStore : NSObject
- (NSArray<SLNote *> *)loadNotes NS_SWIFT_NAME(notes());
- (BOOL)renameNoteWithIdentifier:(NSString *)identifier title:(NSString *)title
                         error:(NSError * _Nullable * _Nullable)error
    NS_SWIFT_NAME(rename(id:title:));
- (NSUInteger)noteCount NS_REFINED_FOR_SWIFT;
@end
NS_ASSUME_NONNULL_END

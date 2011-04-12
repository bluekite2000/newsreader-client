

@interface MWFeedParser ()

#pragma mark Private Properties

// Feed Downloading Properties
@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableData *asyncData;
@property (nonatomic, retain) NSString *asyncTextEncodingName;

// Parsing Properties
@property (nonatomic, retain) NSXMLParser *feedParser;
@property (nonatomic, retain) NSString *currentPath;
@property (nonatomic, retain) NSMutableString *currentText;
@property (nonatomic, retain) NSDictionary *currentElementAttributes;
@property (nonatomic, retain) MWFeedItem *item;
@property (nonatomic, retain) MWFeedInfo *info;
@property (nonatomic, copy) NSString *pathOfElementWithXHTMLType;

#pragma mark Private Methods

// Parsing Methods
- (void)reset;
- (void)abortParsingEarly;
- (void)parsingFinished;
- (void)parsingFailedWithErrorCode:(int)code andDescription:(NSString *)description;
- (void)startParsingData:(NSData *)data textEncodingName:(NSString *)textEncodingName;

// Dispatching to Delegate
- (void)dispatchFeedInfoToDelegate;
- (void)dispatchFeedItemToDelegate;

// Error Handling

// Misc
- (BOOL)createEnclosureFromAttributes:(NSDictionary *)attributes andAddToItem:(MWFeedItem *)currentItem;
- (BOOL)processAtomLink:(NSDictionary *)attributes andAddToMWObject:(id)MWObject;

@end
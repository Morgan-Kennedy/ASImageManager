# ASImageManager
An already set up image download and cache manager to handle ASNetworkImageNode image caching and downloading on initialisation. Perfect for projects using Facebook's AsyncDisplayKit; the Image Manager utilises SDWebImage to handle both the async downloading, and image caching.

##CocoaPods

```
pod "ASImageManager"
```

#####import header

```
#import "ASImageManager.h"
```

#####Usage on a ASNetworkImageNode

```
_imageNode = [[ASNetworkImageNode alloc] initWithCache:[ASImageManager sharedImageManager] downloader:[ASImageManager sharedImageManager]];
_imageNode.URL = [NSURL URLWithString:@"http://hello-kitty.sanriotown.com/images/kitty.png"];
[self.view addSubnode:_imageNode];
```

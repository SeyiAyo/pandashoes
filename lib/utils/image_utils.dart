import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUtils {
  static const String fallbackImageUrl = 'https://via.placeholder.com/300x300?text=Product+Image';
  static const Duration cacheTimeout = Duration(days: 7);  // Cache images for 7 days

  static Widget buildProductImage(String? imageUrl, {double? width, double? height}) {
    final effectiveUrl = imageUrl?.isNotEmpty == true ? imageUrl! : fallbackImageUrl;
    
    return CachedNetworkImage(
      imageUrl: effectiveUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 300),
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      maxHeightDiskCache: 1500,  // Max height to resize the image to when caching
      memCacheHeight: 800,  // Max height of images in memory cache
      
      // Show a shimmer loading effect while loading
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      
      // Error widget when image fails to load
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              color: Colors.grey[600],
              size: 40,
            ),
            if (url != fallbackImageUrl) 
              const SizedBox(height: 8),
            if (url != fallbackImageUrl)
              TextButton(
                onPressed: () {
                  // This will force a reload of the image
                  CachedNetworkImage.evictFromCache(url);
                },
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }

  // Preload images for smoother scrolling
  static Future<void> preloadImages(List<String> imageUrls, BuildContext context) async {
    for (final url in imageUrls) {
      if (url.isNotEmpty) {
        try {
          await precacheImage(
            CachedNetworkImageProvider(url),
            context,
          );
        } catch (e) {
          // Silently handle preloading errors
          continue;
        }
      }
    }
  }

  // Clear the entire image cache
  static void clearImageCache() {
    imageCache.clear();
    imageCache.clearLiveImages();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}

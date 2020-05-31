import 'dart:math';

import 'package:dio/dio.dart';
import 'package:draw/models/image_asset.dart';
import 'package:draw/models/image_search_result.dart';

class ImageService {
  Future<String> getImageList() async {
    String result;

    try {
      var search = 'mars';
      var searchResponse = await Dio().get(
          "https://images-api.nasa.gov/search?q=$search&media_type=image");

      var imageSerchResult = ImageSearchResult.fromJson(searchResponse.data);

      var random = new Random();
      var index = random.nextInt(imageSerchResult.collection.items.length);

      var assetUrl =
          'https://images-api.nasa.gov/asset/${imageSerchResult.collection.items[index].data[0].nasaId}';

      print(assetUrl);

      var assetResponse = await Dio().get(assetUrl);
      var imageAsset = ImageAsset.fromJson(assetResponse.data);

      result = imageAsset.collection.items
          .where((element) =>
              (element.href.contains('medium') ||
                  element.href.contains('large') ||
                  element.href.contains('orig') ||
                  element.href.contains('thumb')) &&
              element.href.contains('jpg'))
          .first
          .href;

      print(result);
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<String> get1() async {
    String result;

    try {
      var search = 'mars';
      var searchResponse = await Dio()
          .get("https://images-api.nasa.gov/search?q=$search&media_type=image");

      var imageSerchResult = ImageSearchResult.fromJson(searchResponse.data);

      var random = Random();
      var index =
          random.nextInt(imageSerchResult.collection.metadata.totalHits);

      //if(index > )

      var assetUrl =
          'https://images-api.nasa.gov/asset/${imageSerchResult.collection.items[index].data[0].nasaId}';

      var assetResponse = await Dio().get(assetUrl);
      var imageAsset = ImageAsset.fromJson(assetResponse.data);

      result = imageAsset.collection.items
          .where((element) =>
              (element.href.contains('medium') ||
                  element.href.contains('large')) &&
              element.href.contains('jpg'))
          .first
          .href;

      print(result);
    } catch (e) {
      print(e);
    }

    return result;
  }
}

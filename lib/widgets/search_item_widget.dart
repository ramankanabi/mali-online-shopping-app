import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:online_shopping/resources/values_manager.dart';
import "../cacheManager/image_cache_manager.dart" as cache;
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productViewScreen,
          arguments: [product.prodId, false],
        );
      },
      child: Container(
          height: AppSize.s100,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: ColorManager.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: LayoutBuilder(builder: (context, bxct) {
              return Row(
                children: [
                  Container(
                    height: bxct.maxHeight,
                    width: bxct.maxWidth * 0.20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(product.images[0],
                              cacheManager:
                                  cache.ImageCacheManager().cacheManager),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: getMediumStyle(
                            color: ColorManager.grey, fontSize: FontSize.s20),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: bxct.maxWidth * 0.70,
                        child: Text(
                          product.discreption_EN.toString(),
                          maxLines: 1,
                          style: getRegularStyle(
                              color: ColorManager.lightGrey,
                              fontSize: FontSize.s14),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (product.priceDiscount == 0) ...{
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: product.price.toString(),
                                style: getBoldStyle(
                                    color: ColorManager.orange,
                                    fontSize: FontSize.s16),
                              ),
                              TextSpan(
                                text: " IQD",
                                style: getBoldStyle(
                                    color: ColorManager.orange,
                                    fontSize: FontSize.s10),
                              ),
                            ],
                          ),
                        ),
                      } else ...{
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: product.price.toString(),
                                    style: TextStyle(
                                      fontSize: FontSize.s12,
                                      fontWeight: FontWeight.normal,
                                      color: ColorManager.lightGrey,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " IQD",
                                    style: getBoldStyle(
                                        color: ColorManager.lightGrey,
                                        fontSize: FontSize.s8),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: product.priceDiscount.toString(),
                                    style: getBoldStyle(
                                        color: ColorManager.orange,
                                        fontSize: FontSize.s16),
                                  ),
                                  TextSpan(
                                    text: " IQD",
                                    style: getBoldStyle(
                                        color: ColorManager.orange,
                                        fontSize: FontSize.s10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      }
                    ],
                  )
                ],
              );
            }),
          )),
    );
  }
}

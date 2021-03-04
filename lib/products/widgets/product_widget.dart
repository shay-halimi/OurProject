import 'package:cookpoint/products/products.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:products_repository/products_repository.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  factory ProductWidget.fake(String id) {
    return ProductWidget(
        product: Product.empty.copyWith(
      id: id,
      title: 'הדאל של גל',
      description: '''דאל טרי עשוי בעבודת יד יום יום מעדשים כתומות

תערובת תבלינים ,גזר , בצל

מנה 20 ש''ח
אורז 10 ש''ח
5 מנות עם אורז - 80 ש''ח

הזמנות עד יום חמישי ב18:00
ניתן לפנות בוואצאפ או בטלפון 
''',
      price: Money.empty.copyWith(amount: 29.90),
      media: {
        'https://veg.co.il/wp-content/uploads/red-lentil-dal-966x587.jpg'
      },
      tags: {'טבעוני', 'צמחוני'},
    ));
  }

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.of(context).push<void>(ProductPage.route(product: product)),
      child: Card(
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: _PhotoWidget(photo: product.media.first),
            ),
            Flexible(
              child: _TitleWidget(product: product),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoWidget extends StatelessWidget {
  const _PhotoWidget({
    Key key,
    @required this.photo,
  }) : super(key: key);

  final String photo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: photo,
            child: Image.network(
              photo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            product.title,
            style: theme.textTheme.headline6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${product.price.amount} ₪',
            style:
                theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w300),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      subtitle: TagsWidget(tags: product.tags),
    );
  }
}

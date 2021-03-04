import 'package:cookpoint/products/products.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:products_repository/products_repository.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key key, @required this.product}) : super(key: key);

  final Product product;

  static Route route({
    @required Product product,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ProductPage(product: product),
      fullscreenDialog: true,
    );
  }

  static Future<void> showDialog({
    @required BuildContext context,
    @required Product product,
  }) {
    return showGeneralDialog<void>(
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return ProductPage(
          product: product,
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _photos(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'הדאל של גל',
                        style: theme.textTheme.headline5,
                      ),
                      Text(
                        '21.90 ₪',
                        style: theme.textTheme.headline5
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  TagsWidget(tags: product.tags),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.description,
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListTile(
        dense: true,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Gal_Gadot_2018_cropped_retouched.jpg/250px-Gal_Gadot_2018_cropped_retouched.jpg'),
        ),
        title: const Text('גל גדות'),
        subtitle: const Text('פתח תקווה'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.whatsapp),
              onPressed: () => null,
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () => null,
            ),
            IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () => null,
            ),
          ],
        ),
        onTap: () => null,
      ),
    );
  }

  Widget _photos(BuildContext context) {
    /// todo loop media.

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Hero(
        tag: 'https://veg.co.il/wp-content/uploads/red-lentil-dal-966x587.jpg',
        child: Image.network(
          'https://veg.co.il/wp-content/uploads/red-lentil-dal-966x587.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

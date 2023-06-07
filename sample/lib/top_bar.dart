import 'package:badges/badges.dart' as badges;
import 'package:bakalauras/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seo/seo_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();

    return AppBar(
      title: SeoText(
        child:Text(title)
      ),
      actions: [
        badges.Badge(
          showBadge: cart.products.isNotEmpty,
          position: const badges.BadgePosition(top: 1, end: 1),
          animationType: badges.BadgeAnimationType.scale,
          badgeContent: Text(cart.products.length.toString()),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.go("/cart"),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/config/custom_route.dart';
import 'package:shop_app/screens/splash_screen.dart';

import 'screens/authentication_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'screens/cart_screen.dart';

import 'models/authentication.dart';
import 'models/products.dart';
import 'models/cart.dart';
import 'config/color_scheme.dart';
import 'models/orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Authentication(),
        ),
        ChangeNotifierProxyProvider<Authentication, Products>(
          create: (BuildContext ctx) => Products('', '', []),
          lazy: false,
          update: (BuildContext ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (BuildContext ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Authentication, Orders>(
          create: (BuildContext ctx) => Orders('', '', []),
          lazy: false,
          update: (BuildContext ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Authentication>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: buildMaterialColor(
                const Color(0xFFa5d6a7),
              ),
            ).copyWith(
              secondary: buildMaterialColor(
                const Color(0xFFff8a65),
              ),
            ),
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              TargetPlatform.macOS: CustomPageTransitionBuilder(),
              TargetPlatform.windows: CustomPageTransitionBuilder(),
              TargetPlatform.linux: CustomPageTransitionBuilder(),
            }),
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuthenticated
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthenticationScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}

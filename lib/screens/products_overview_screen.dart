import 'package:flutter/material.dart';
import 'package:shop/screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';

enum FilterOptions{
  Favourites,
  All
}

class ProductsOverviewScreen extends StatefulWidget {


  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
//    Provider.of<Products>(context).fetchAndSetProducts();
//    Future.delayed(Duration.zero).then((_) {
//      Provider.of<Products>(context).fetchAndSetProducts();
//    });
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    if(_isInit){
      _isLoading = true;
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if(selectedValue == FilterOptions.Favourites){
                  _showOnlyFavourites = true;
                }else{
                  _showOnlyFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text('Only Favourites'),
                    value: FilterOptions.Favourites),
                PopupMenuItem(
                    child: Text('Show All'),
                    value: FilterOptions.All),
              ],
          ),
          Consumer<Cart>(builder: (_, cart, ch) => Badge(
              child: ch,
                value: cart.itemCount.toString()
          ),
          child: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ): ProductsGrid(_showOnlyFavourites)
    );
  }
}


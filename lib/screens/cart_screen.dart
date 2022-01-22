import 'package:flutter/material.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),

      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                  Spacer(),
                  SizedBox(width: 10,),
                  Chip(
                    label: Text(
                      '₹${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.title.color,
                  ),),
                  backgroundColor: Theme.of(context).primaryColor,
                  ),
                  PlaceOrder(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      productId: cart.items.keys.toList()[i],
                      title: cart.items.values.toList()[i].title,
                      quantity: cart.items.values.toList()[i].quantity,
                      price: cart.items.values.toList()[i].price,
                      imageUrl: cart.items.values.toList()[i].imageUrl,)
              )
          )
        ],
      ),
    );
  }
}

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() :
      Text("PLACE ORDER"),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
            ? null : () async{
        setState(() {
          _isLoading = true;
        });
          await Provider.of<Orders>(
              context, listen: false).addOrder(
              widget.cart.items.values.toList(),
              widget.cart.totalAmount);
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        },

        textColor: Theme.of(context).primaryColor,

    );
  }
}

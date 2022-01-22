import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.imageUrl
});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items ={};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    var leng = 0;
    _items.forEach((key, cartItem) {
      leng += cartItem.quantity;
    });
    return leng;
  }



  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
  void addItem(String productId, double price, String title, String imageUrl) {
    if(_items.containsKey(productId)){
      _items.update(productId, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl
      )
      );
    }
    else{
      _items.putIfAbsent(productId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        quantity: 1,
        price: price,
        imageUrl: imageUrl
      )
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId))
      return;
    if(_items[productId].quantity > 1)
      _items.update(productId,
              (existingCartItem) => CartItem(
                  id: existingCartItem.id,
                  title: existingCartItem.title,
                  price: existingCartItem.price,
                  imageUrl: existingCartItem.imageUrl,
                  quantity: existingCartItem.quantity -1 ));
    else
      _items.remove(productId);
    notifyListeners();
  }
}
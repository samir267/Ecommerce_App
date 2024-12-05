import 'dart:convert';
import 'package:ecom/services/order_service.dart';
import 'package:ecom/services/product_service.dart'; // Importez le service
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecom/models/productCart.dart'; // Importez votre modèle de produit
import 'package:ecom/sqlite/UserDatabase.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  bool isError = false;
  late List<ProductCart> cartItems = []; // Liste des produits dans le panier
  Map<int, int> quantities = {}; // Associe l'ID d'un produit à sa quantité

  final ProductService _productService = ProductService();
  final OrderService _orderService = OrderService();
  String? userId;  // Ajoutez la variable pour stocker l'ID de l'utilisateur
  String? accessToken; // Ajoutez la variable pour stocker le token d'accès

  @override
  void initState() {
    super.initState();
    _getUser();  // Récupérer les données utilisateur dès le démarrage de la page
  }

  // Récupérer les données de l'utilisateur
  Future<void> _getUser() async {
    try {
      final userDatabase = UserDatabase();
      final user = await userDatabase.getUser();
      if (user != null) {
        setState(() {
          userId = user['userId'].toString();
          accessToken = user['accessToken'];
        });
        fetchCartByUserId();  // Récupérer le panier après avoir obtenu l'ID de l'utilisateur
      } else {
        setState(() {
          userId = null;
          accessToken = null;
        });
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      setState(() {
        userId = null;
        accessToken = null;
      });
    }
  }

  // Utilisez la méthode fetchCartByUserId du service
  Future<void> fetchCartByUserId() async {
    if (userId == null) return; // Assurez-vous que l'ID de l'utilisateur est valide

    try {
      final response = await _productService.fetchCartByUserId(int.parse(userId!)); // Utilisez userId ici

      if (response != null && response['cartItems'] != null) {
        List<dynamic>? values = response['cartItems']['\$values'];
        if (values != null) {
          setState(() {
            cartItems = values
                .map((item) =>
                    item['product'] != null ? ProductCart.fromJson(item['product']) : null)
                .whereType<ProductCart>()
                .toList();

            // Initialiser les quantités à 1 pour chaque produit
            for (var product in cartItems) {
              quantities[product.id] = 1;
            }
          });
          print("Fetched cart products: $cartItems");
          print("Initialized quantities: $quantities");
        } else {
          print("No cart items found in response.");
        }
      } else {
        print("Response is null or does not contain 'cartItems'.");
      }
    } catch (error) {
      print("Erreur lors de la récupération du panier: $error");
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Votre méthode de calcul du prix total reste inchangée
  double calculateTotalPrice() {
    return cartItems.fold(
      0.0,
      (total, item) => total + (item.price * (quantities[item.id] ?? 1)),
    );
  }

  @override
  void dispose() {
    _productService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        backgroundColor: Colors.blue.shade700,
        title: Text(
          "My Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Affichage de la liste des produits dans le panier
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length + (isLoading ? 1 : 0), // +1 pour ajouter l'indicateur de chargement
              itemBuilder: (context, index) {
                if (isLoading && index == cartItems.length) {
                  return Center(child: CircularProgressIndicator());
                }

                final item = cartItems[index];
                return _buildCartItem(item); // Afficher chaque produit du panier
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              shadowColor: Colors.blue.shade200,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "€${totalPrice.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shipping",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "€5.00",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1.2, color: Colors.grey.shade400),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "€${calculateTotalPrice().toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centre le bouton horizontalement
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            _showOrderModal(context); // Affiche le modal
                          },
                          child: Text('Order Now'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderModal(BuildContext context) {
    String shippingAddress = ""; // Valeur initiale pour l'adresse
    String paymentMethod = ""; // Valeur initiale pour la méthode de paiement

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Complete Your Order",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ pour l'adresse de livraison
              TextField(
                onChanged: (value) {
                  shippingAddress = value;
                },
                decoration: InputDecoration(
                  labelText: "Shipping Address",
                  hintText: "Enter your shipping address",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Dropdown pour la méthode de paiement
              DropdownButtonFormField<String>(
                value: paymentMethod.isEmpty ? null : paymentMethod,
                onChanged: (value) {
                  if (value != null) {
                    paymentMethod = value;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Payment Method",
                  border: OutlineInputBorder(),
                ),
                items: ["En ligne", "A la livraison"]
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            // Bouton pour annuler
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le modal
              },
              child: Text("Cancel"),
            ),
            // Bouton pour confirmer
            ElevatedButton(
              onPressed: () {
                if (shippingAddress.isEmpty || paymentMethod.isEmpty) {
                  // Si l'un des champs est vide, retournez
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                createOrder(shippingAddress, paymentMethod);
                Navigator.of(context).pop();
              },
              child: Text("Confirm Order"),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour créer la commande
 Future<void> createOrder(String shippingAddress, String paymentMethod) async {
  if (userId == null) {
    print('User is not authenticated');
    return;
  }

  // Création des données de la commande
  final orderData = {
    'userId': userId,  // Assurez-vous que userId est un String valide
    'shippingAddress': shippingAddress,
    'paymentMethod': paymentMethod,
    // 'totalPrice': calculateTotalPrice(), // Assurez-vous que cette fonction est définie si nécessaire
  };

  try {
    // Cast explicite pour s'assurer que les valeurs sont des String
    final String userIdString = orderData['userId'] as String; 
    final String shippingAddressString = orderData['shippingAddress'] as String;
    final String paymentMethodString = orderData['paymentMethod'] as String;
print("Order data: ${jsonEncode({
  'userId': userIdString,
  'shippingAddress': shippingAddressString,
  'paymentMethod': paymentMethodString,
  'subtotal': double.parse(calculateTotalPrice().toStringAsFixed(2)),
})}");

    // Crée une instance du service OrderService
    final orderService = OrderService();

    // Appel de la méthode createOrder avec des String valides
    await orderService.createOrder(
      userId: userIdString,
      address: shippingAddressString,
      paymentMethod: paymentMethodString,
      subtotal: double.parse(calculateTotalPrice().toStringAsFixed(2)),
    );
     Fluttertoast.showToast(
          msg: "Order created successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: const Color.fromARGB(255, 182, 123, 123),
          textColor: Colors.white,
          fontSize: 16.0
        );
    
    print("Order created successfully.");
    print("userId $userIdString");
        orderService.deleteUserCart(int.parse(userId!));

  } catch (e) {
    print("Failed to create order: $e");
  }
}


  // Construire chaque élément du panier
  Widget _buildCartItem(ProductCart item) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Image.network(item.image),
        title: Text(item.name),
        subtitle: Text("€${item.price}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                setState(() {
                  if (quantities[item.id]! > 1) {
                    quantities[item.id] = quantities[item.id]! - 1;
                  }
                });
              },
            ),
            Text(quantities[item.id].toString()),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  quantities[item.id] = quantities[item.id]! + 1;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

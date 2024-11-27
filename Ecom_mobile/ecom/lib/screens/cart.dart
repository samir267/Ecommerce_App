import 'dart:convert';
import 'package:ecom/services/product_service.dart'; // Importez le service
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ecom/models/productCart.dart'; // Importez votre modèle de produit
import 'package:ecom/sqlite/UserDatabase.dart';


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
          print("dans home screen ${user['userId']}");
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(ProductCart item) {
    int quantity = quantities[item.id] ?? 1; // Obtenir la quantité depuis l'état

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.blue.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                item.image,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "€${item.price}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Si la clé n'existe pas, initialiser à 1 avant d'incrémenter
                              quantities[item.id] = (quantities[item.id] ?? 1) + 1;
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.blue.shade700),
                        ),
                        Text(
                          "${quantities[item.id]}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              // Si la quantité est plus que 1, décrémenter
                              if ((quantities[item.id] ?? 1) > 1) {
                                quantities[item.id] = (quantities[item.id] ?? 1) - 1;
                              }
                            });
                          },
                          icon: Icon(Icons.remove, color: Colors.blue.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

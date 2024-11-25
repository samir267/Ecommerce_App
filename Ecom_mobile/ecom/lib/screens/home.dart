import 'package:ecom/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/services/product_service.dart';
import 'package:ecom/models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = "";

  // Variable pour suivre l'index sélectionné
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await _productService.fetchProducts();

      // Afficher la réponse dans les logs pour vérifier son contenu
      print('Response: ${response.toString()}');  // Pour vérifier la structure de la réponse

      // Utiliser la clé '$values' pour accéder à la liste des produits
      final productsJson = response['\$values'];  // Utilisation de l'échappement du '$'

      if (productsJson is List) {
        final products = productsJson.map((productJson) {
          return Product.fromJson(productJson); // Assurez-vous que la méthode fromJson est correcte
        }).toList();

        setState(() {
          _products = products;
          _isLoading = false;
        });
      } else {
        throw Exception("Le format des produits est incorrect.");
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
      print('Error: $error'); // Afficher l'erreur dans la console
    }
  }

  // Méthode pour gérer la sélection d'un item


  final List<String> categories = ["All", "Electronics", "Fashion", "Toys", "Sports", "Home",];
  final List<IconData> categoryIcons = [
    Icons.category, // All
    Icons.devices, // Electronics
    Icons.checkroom, // Fashion
    Icons.toys, // Toys
    Icons.sports, // Sports
    Icons.home, // Home
  ];

  void _onCategoryTapped(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });
  }

 void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });

  // Naviguer vers les pages appropriées
  switch (index) {
    case 0:
      Navigator.pushNamed(context, AppRoutes.home);
      break;
    case 1:
      Navigator.pushNamed(context, AppRoutes.home); // Remplacer par la route des catégories si elle existe
      break;
    case 2:
      Navigator.pushNamed(context, AppRoutes.cartscreen); // Remplacer par la route du panier si elle existe
      break;
    case 3:
      Navigator.pushNamed(context, AppRoutes.profile);
      break;
    default:
      break;
  }
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue.shade700,
      elevation: 0,
      title: const Text("E-Commerce",
      style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Carousel Slider
                    CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                      ),
                      items: _products.map((product) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(product.image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    // Categories Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            int index = categories.indexOf(category);
                            return GestureDetector(
                              onTap: () => _onCategoryTapped(index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      categoryIcons[index],
                                      size: 30,
                                      color: _selectedCategoryIndex == index
                                          ? Colors.blue.shade700
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category,
                                      style: TextStyle(
                                        color: _selectedCategoryIndex == index
                                            ? Colors.blue.shade700
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Product Grid
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${product.price} €",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.shopping_cart,
                                        color: Colors.black,
                                        size: 23,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
    // Ajout du BottomNavigationBar
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.blue.shade400,
      selectedItemColor: Colors.blue.shade400,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "Cart",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    ),
  );
}
}
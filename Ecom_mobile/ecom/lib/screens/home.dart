import 'package:ecom/models/categorie_model.dart';
import 'package:ecom/routes/app_routes.dart';
import 'package:ecom/screens/cart.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom/services/product_service.dart';
import 'package:ecom/models/product_model.dart';
import 'package:ecom/services/category_service.dart';
import 'package:ecom/sqlite/UserDatabase.dart'; // Importez votre classe de base de données



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  List<Product> _products = [];
  List<Category> _categories = [];  

  bool _isLoading = true;
  String _errorMessage = "";
  int _selectedIndex = 0;
  int _selectedCategoryIndex = 0;
  String? userId;
  String? accessToken;
  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _fetchCategories();
    _getUser();
  }

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

   int getSelectedCategoryId() {
    if (_categories.isNotEmpty && _selectedCategoryIndex >= 0) {
      return _categories[_selectedCategoryIndex].id; // Retourne l'ID de la catégorie sélectionnée
    }
    return -1; // Retourne -1 si aucune catégorie n'est sélectionnée
  }
Future<void> _fetchCategories() async {
  setState(() {
    _isLoading = true;
    
  });

  try {
    final List<Category> categories = await _categoryService.fetchCategories();

    // Loguer les noms et ID des catégories
    for (var category in categories) {
      print("ID: ${category.id}, Nom: ${category.name}");
    }

    setState(() {
      _categories = categories; 
      _isLoading = false;
    });
  } catch (error) {
    print("Erreur : $error");

    setState(() {
      _errorMessage = error.toString(); // Assurez-vous que _errorMessage est de type String
      _isLoading = false;
    });
  }
}




  Future<void> _fetchProducts() async {
    try {
      final response = await _productService.fetchProducts();

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



Future<void> _fetchProductsByCategory(int categoryId) async {
  try {
    final List<Product> products = await _productService.fetchProductsByCategory(categoryId);

    print('Products for category $categoryId: ${products.length} products found');

    if (products.isEmpty) {
      // Afficher un SnackBar si aucun produit n'est trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Aucun produit trouvé pour cette catégorie."),
          duration: const Duration(seconds: 1), // Dure 1 seconde
        ),
      );

      // Attendre que le SnackBar disparaisse avant de charger tous les produits
      await Future.delayed(const Duration(seconds: 1));
      _fetchProducts();  // Charger tous les produits à nouveau
    } else {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  } catch (error) {
    setState(() {
      _errorMessage = error.toString();
      _isLoading = false;
    });
    print('Error: $error');
  }
}



  void _onCategoryTapped(int index) {
    setState(() {
      _selectedCategoryIndex = index;

      print("selected index"+_selectedCategoryIndex.toString());
    });
        int selectedCategoryId = getSelectedCategoryId();
    print("ID de la catégorie sélectionnée: $selectedCategoryId");

    // Charger les produits de cette catégorie
    if (selectedCategoryId != -1) {
      _fetchProductsByCategory(selectedCategoryId);
    }
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
    // case 1:
    //   Navigator.pushNamed(context, AppRoutes.home); // Remplacer par la route des catégories si elle existe
    //   break;
    case 1:
      Navigator.pushNamed(context, AppRoutes.cartscreen); // Remplacer par la route du panier si elle existe
      break;
    case 2:
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
                          children: _categories.map((category) {
                            int index = _categories.indexOf(category);
                            return GestureDetector(
                              onTap: () => _onCategoryTapped(index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 30,
                                      color: _selectedCategoryIndex == index
                                          ? Colors.blue.shade700
                                          : Colors.black,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      category.name,
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
                                     IconButton(
  icon: const Icon(
    Icons.shopping_cart,
    color: Colors.black,
    size: 23,
  ),
  onPressed: () async {
    await _getUser();  // Assurez-vous d'obtenir les données de l'utilisateur avant d'ajouter au panier.

    if (userId != null) {  
      final productId = product.id;  // Récupérer l'ID du produit
      final parsedUserId = int.tryParse(userId ?? '');

      if (parsedUserId != null) {
        // Appel à la fonction addToCart dans votre service
        await _productService.addToCart(parsedUserId, productId, 1);  // 1 est la quantité que vous ajoutez par défaut

        // Affichage d'un message de succès ou d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produit ajouté au panier.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('userId non valide');
      }
    } else {
      print('Utilisateur non trouvé ou non authentifié');
      // Vous pouvez également afficher un message d'erreur ici si nécessaire
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Utilisateur non authentifié. Veuillez vous connecter.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
)


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
  selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
  unselectedItemColor: Colors.black,
  showUnselectedLabels: true,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    // L'élément Categories est commenté, il ne sera pas affiché
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
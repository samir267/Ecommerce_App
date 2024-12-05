import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';
import 'package:ecom/sqlite/UserDatabase.dart';

class ProductDetails extends StatefulWidget {
  final int productId;

  const ProductDetails({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late Future<Product> _productFuture;
  late Future<List<dynamic>> _commentsFuture;  // For the comments
  TextEditingController _reviewController = TextEditingController(); // Controller for the review input
  String userId = '';  // Initialize userId as an empty string
  late UserDatabase database;
  bool isLoading = true;  // To track loading state

  @override
  void initState() {
    super.initState();
    database = UserDatabase();

    // Fetch product details when the widget is initialized
    _productFuture = ProductService().fetchProductById(widget.productId);
    _commentsFuture = ProductService().fetchCommentsByProductId(widget.productId); // Fetch comments
    
    // Get the userId on init
    _getUser();
  }

  // Function to get the user ID from the local database
  Future<void> _getUser() async {
    try {
      final userMap = await database.getUser();
      if (userMap != null && userMap.isNotEmpty) {
        setState(() {
          userId = userMap['userId'].toString();  // Set userId
          isLoading = false;  // Stop loading once the user ID is set
        });
      } else {
        setState(() {
          userId = 'No user found';  // In case no user is found
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error retrieving user: $e');
      setState(() {
        userId = 'Error retrieving user';
        isLoading = false;
      });
    }
  }

  // Function to submit the review
  void _submitReview() {
  final reviewText = _reviewController.text.trim();
  
  if (reviewText.isNotEmpty && userId.isNotEmpty && userId != 'No user found') {
    try {
      // Convertir userId en int, si possible
      int parsedUserId = int.parse(userId);  // Convertir la chaîne en entier

      // Soumettre l'avis avec l'ID utilisateur converti
      ProductService().submitReview(
        content: reviewText,
        productId: widget.productId,
        userId: parsedUserId,  // Passer l'ID utilisateur en tant qu'entier
      ).then((_) {
        _reviewController.clear(); // Effacer après soumission
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Avis soumis')));
        
        // Optionnel : Rafraîchir la liste des commentaires après soumission
        setState(() {
          _commentsFuture = ProductService().fetchCommentsByProductId(widget.productId);
        });
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de soumission : $e')));
      });
    } catch (e) {
      // En cas d'erreur de conversion de l'ID utilisateur
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ID utilisateur invalide')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez entrer un avis et vérifier que l\'utilisateur est connecté')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du produit',
              style: TextStyle(color: Colors.white),

        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final product = snapshot.data!;
            return SingleChildScrollView(  // Make the entire content scrollable
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    product.image.isNotEmpty
                        ? Image.network(
                            product.image,  // Assuming the URL is in the product model
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: Placeholder(), // Placeholder for missing image
                          ),
                    SizedBox(height: 16),
                    // Product Name
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    // Product Price
                    Text(
                      'Prix: \$${product.price}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                    // Product Description
                    Text(
                      'Description: ${product.description}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 8),
                    // Product Quantity
                    Text(
                      'Quantité: ${product.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16),
                    
                    // Review Input
                    Text(
                      'Donnez votre avis:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextField(
                      controller: _reviewController,
                      maxLines: 4,  // Allow multiple lines for longer reviews
                      decoration: InputDecoration(
                        hintText: 'Écrivez votre avis ici...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(8.0),
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitReview,
                      child: Text('Soumettre l\'avis'),
                    ),
                    SizedBox(height: 32),  // Spacing between review and comments
                    
                    // Comments Section
                    FutureBuilder<List<dynamic>>(
                      future: _commentsFuture,
                      builder: (context, commentsSnapshot) {
                        if (commentsSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (commentsSnapshot.hasError) {
                          return Center(child: Text('Erreur: ${commentsSnapshot.error}'));
                        } else if (commentsSnapshot.hasData && commentsSnapshot.data!.isNotEmpty) {
                          final comments = commentsSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Commentaires:',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              SizedBox(height: 8),
                             ...comments.map((comment) {
  final username = comment['user']?['username'] ?? 'Anonyme';
  final content = comment['content'] != null && comment['content'].isNotEmpty
      ? comment['content']
      : 'Pas de contenu';
  final userImage = comment['user']?['profileImage'] ??
      'https://via.placeholder.com/150'; // Placeholder si pas d'image

  return ListTile(
    leading: CircleAvatar(
      radius: 24, // Taille de l'avatar
      backgroundImage: NetworkImage(userImage), // Affiche l'image de l'utilisateur
      onBackgroundImageError: (error, stackTrace) {
        // Lorsqu'une erreur se produit, une image par défaut est utilisée
      },
    ),
    title: Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(content),
  );
}).toList(),

                            ],
                          );
                        } else {
                          return Center(child: Text('Aucun commentaire disponible'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text('Produit non trouvé'));
          }
        },
      ),
    );
  }
}

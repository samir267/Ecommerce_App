import 'package:flutter/material.dart';
import 'package:ecom/sqlite/UserDatabase.dart'; // Importez votre classe de base de données
import 'package:ecom/services/user_service.dart'; // Importez le service UserService

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // Déclaration des variables globales pour l'état
  String? userId;
  String? firstName;
  String? address;
  String? email;
  String? phoneNumber;

  // Contrôleurs de texte
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUser(); // Récupérer les informations utilisateur depuis SQLite
  }

  Future<void> _getUser() async {
    try {
      final userDatabase = UserDatabase();
      final userMap = await userDatabase.getUser();

      // Récupérez l'ID utilisateur depuis SQLite
      setState(() {
        userId = userMap?['userId'].toString(); // Convertissez en String si nécessaire
      });

      // Récupérez les détails utilisateur depuis l'API (UserService)
      final userService = UserService();
      final userData = await userService.getUser(int.parse(userId!)); // Passez l'ID

      setState(() {
        firstName = userData['username'];
        address = userData['address'];
        email = userData['email'];
        phoneNumber = userData['phone'];

        // Initialiser les contrôleurs avec les données récupérées
        firstNameController.text = firstName ?? '';
        addressController.text = address ?? '';
        emailController.text = email ?? '';
        phoneNumberController.text = phoneNumber ?? '';
      });
    } catch (e) {
      print('Error retrieving user data: $e');
      setState(() {
        userId = null; // Réinitialisez l'ID utilisateur en cas d'erreur
      });
    }
  }

  Future<void> _updateUserProfile() async {
    if (userId == null) {
      // Si userId est null, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID is not available. Please try again.")),
      );
      return;
    }

    try {
      final userService = UserService();
      final userData = {
        'username': firstNameController.text,
        'address': addressController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
      };
      print("userData $userData");
      // Mettez à jour les informations utilisateur
      await userService.updateUser(5, userData);

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      // Gérer les erreurs
      // ScaffoldMessenger.of(context).showSnackBar(
      //   // SnackBar(content: Text("Error updating profile: $e")),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        elevation: 0,
        title: const Text("Update Profile", style: TextStyle(fontSize: 22)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const NetworkImage("https://i.imgur.com/IXnwbLk.png"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.shade400,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            // Logique pour modifier l'image
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("First Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "Enter your First name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: "Enter your Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Email", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Phone Number", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateUserProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Save Changes", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

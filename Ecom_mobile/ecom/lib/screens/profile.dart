import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
backgroundColor: Colors.blue.shade700, // Remplacer la couleur
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontSize: 22,color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Image de profil et nom de l'utilisateur
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://i.imgur.com/IXnwbLk.png"),
          ),
          const SizedBox(height: 15),
          const Text(
            "Sepide", 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            "theflutterway@gmail.com",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          // Carte d'informations de l'utilisateur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileMenuListTile(
                      icon: Icons.edit,
                      title: "Update Profile",
                      onTap: () {
                        Navigator.pushNamed(context, "/updateprofile");
                      },
                    ),
                    ProfileMenuListTile(
                      icon: Icons.help_outline,
                      title: "Help",
                      onTap: () {
                        Navigator.pushNamed(context, "/help");
                      },
                    ),
                    ProfileMenuListTile(
                      icon: Icons.exit_to_app,
                      title: "Log out ",
                      onTap: () {
                        // Code pour déconnexion
                      },
                    ),
                     ProfileMenuListTile(
                      icon: Icons.lock_reset,
                      title: "Reset Password ",
                      onTap: () {
                        // Code pour déconnexion
                      },
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
}

class ProfileMenuListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey.shade800),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}

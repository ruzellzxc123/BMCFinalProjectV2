// ...existing code...
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _bg = Color(0xFF0F0D0E);
  static const Color _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('ZellLux', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: _gold,
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 920),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Welcome card
                Card(
                  color: Colors.black87,
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.shopping_bag, color: Colors.white70, size: 36),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome${user != null ? ', ${user.email}' : ''}',
                                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 6),
                              Text('Explore the latest collection from ZellLux.',
                                  style: TextStyle(color: Colors.white.withOpacity(0.85))),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _gold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Shop Now'),
                        )
                      ],
                    ),
                  ),
                ),
                // Spacer
                const SizedBox(height: 28),
                // Placeholder grid (elegant product tiles)
                Expanded(
                  child: GridView.builder(
                    itemCount: 6,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.grey.shade900,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                ),
                                child: const Center(child: Icon(Icons.image, color: Colors.white24, size: 48)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Luxury Item', style: TextStyle(color: Colors.white.withOpacity(0.95), fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 6),
                                  Text('\$1,250', style: TextStyle(color: _gold, fontWeight: FontWeight.w700)),
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
        ),
      ),
    );
  }
}
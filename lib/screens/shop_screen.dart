import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/eco_background.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  int coins = 0;
  List<String> ownedItems = [];
  Map<String, String> equipped = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    setState(() {
      coins = doc.data()?['coins'] ?? 0;
      ownedItems = List<String>.from(doc.data()?['ownedItems'] ?? []);
      equipped = Map<String, String>.from(doc.data()?['equipped'] ?? {});
    });
  }

  void _buyItem(Map<String, dynamic> item) async {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final int price = item['price'];

    if (coins < price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough coins")),
      );
      return;
    }

    final newCoins = coins - price;

    await userDoc.update({
      'coins': newCoins,
      'ownedItems': FieldValue.arrayUnion([item['id']])
    });

    setState(() {
      coins = newCoins;
      ownedItems.add(item['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Purchased ${item['name']}!")),
    );
  }

  Future<void> _equipItem(Map<String, dynamic> item) async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    await doc.update({
      'equipped.${item['type']}': item['image'],
    });

    setState(() {
      equipped[item['type']] = item['image'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${item['name']} equipped!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFAA00FF), // Your gradient base purple
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '$coins',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: EcoBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Accessories"),
                      _buildItemList('accessory'),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Backgrounds"),
                      _buildItemList('background'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildItemList(String type) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('shop_items')
          .where('type', isEqualTo: type)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!.docs;

        if (items.isEmpty) {
          return const Center(child: Text("No items available."));
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return _buildShopItem(item);
            },
          ),
        );
      },
    );
  }

  Widget _buildShopItem(Map<String, dynamic> item) {
    final bool isOwned = ownedItems.contains(item['id']);
    final bool isEquipped = equipped[item['type']] == item['image'];

    return Container(
      width: 130,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/${item['image']}',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Gradient overlay to darken the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item['price']} Coins",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (isOwned) {
                          _equipItem(item);
                        } else {
                          _buyItem(item);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        textStyle: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                        foregroundColor: Colors.black,
                        backgroundColor: isEquipped
                            ? const Color(0xFF7B1FA2)
                            : const Color(0xFF87CEEB),
                      ),
                      child: Text(
                        isOwned ? (isEquipped ? "Equipped" : "Equip") : "Buy",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

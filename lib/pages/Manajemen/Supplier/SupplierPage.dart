import 'package:flutter/material.dart';
import 'AddSupplier.dart';
import 'EditSupplier.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final Color primaryColor = const Color(0xFFE76F51);

  List<Map<String, String>> allSuppliers = [
    {
      'name': 'Supplier A',
      'contact': '081234567890',
      'address': 'Jl. Mawar No. 10',
    },
    {
      'name': 'Supplier B',
      'contact': '082345678901',
      'address': 'Jl. Melati No. 20',
    },
  ];

  List<Map<String, String>> displayedSuppliers = [];
  String searchQuery = '';
  final Set<int> selectedIndexes = {};
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchSuppliers('');
  }

  void _searchSuppliers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        displayedSuppliers = List.from(allSuppliers);
      } else {
        displayedSuppliers =
            allSuppliers.where((supplier) {
              return (supplier['name'] ?? '').toLowerCase().contains(
                searchQuery,
              );
            }).toList();
      }
    });
  }

  void _startSelectMode(int index) {
    setState(() {
      isSelecting = true;
      selectedIndexes.add(index);
    });
  }

  void _toggleSelect(int index) {
    if (isSelecting) {
      setState(() {
        if (selectedIndexes.contains(index)) {
          selectedIndexes.remove(index);
        } else {
          selectedIndexes.add(index);
        }
      });
    }
  }

  void _cancelSelectMode() {
    setState(() {
      isSelecting = false;
      selectedIndexes.clear();
    });
  }

  void _hapusSupplierTerpilih() {
    setState(() {
      allSuppliers = [
        for (int i = 0; i < allSuppliers.length; i++)
          if (!selectedIndexes.contains(i)) allSuppliers[i],
      ];
      _searchSuppliers(searchQuery);
      selectedIndexes.clear();
      isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Supplier yang dipilih telah dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelecting ? '${selectedIndexes.length} dipilih' : 'Daftar Supplier',
                    style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _cancelSelectMode,
              tooltip: 'Selesai',
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: _searchSuppliers,
              decoration: InputDecoration(
                labelText: 'Cari Supplier...',
                labelStyle: TextStyle(color: primaryColor),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                displayedSuppliers.isEmpty
                    ? const Center(child: Text('Belum ada supplier'))
                    : ListView.builder(
                      itemCount: displayedSuppliers.length,
                      itemBuilder: (context, index) {
                        final supplier = displayedSuppliers[index];
                        final originalIndex = allSuppliers.indexOf(supplier);
                        final isSelected = selectedIndexes.contains(
                          originalIndex,
                        );

                        return GestureDetector(
                          onLongPress: () => _startSelectMode(originalIndex),
                          onTap: () async {
                            if (isSelecting) {
                              _toggleSelect(originalIndex);
                            } else {
                              final updatedSupplier = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditSupplierPage(
                                        name: supplier['name'] ?? '',
                                        email: supplier['email'] ?? '',
                                        contact: supplier['contact'] ?? '',
                                        address: supplier['address'] ?? '',
                                      ),
                                ),
                              );

                              if (updatedSupplier != null &&
                                  updatedSupplier is Map<String, String>) {
                                setState(() {
                                  allSuppliers[originalIndex] = updatedSupplier;
                                  _searchSuppliers(searchQuery);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Supplier diperbarui!'),
                                  ),
                                );
                              }
                            }
                          },
                          child: Card(
                            color: isSelected ? Colors.orange.shade100 : null,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          supplier['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          supplier['contact'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          supplier['address'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: primaryColor,
                                    child: const Icon(
                                      Icons.local_shipping,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton:
          isSelecting && selectedIndexes.isNotEmpty
              ? FloatingActionButton(
                onPressed: _hapusSupplierTerpilih,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              )
              : FloatingActionButton(
                onPressed: () async {
                  final newSupplier = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSupplierPage(),
                    ),
                  );

                  if (newSupplier != null &&
                      newSupplier is Map<String, String>) {
                    setState(() {
                      allSuppliers.add(newSupplier);
                      _searchSuppliers(searchQuery);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Supplier ditambahkan!')),
                    );
                  }
                },

                backgroundColor: primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
    );
  }
}

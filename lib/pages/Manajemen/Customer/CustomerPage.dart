import 'package:flutter/material.dart';
import 'AddCustomer.dart';
import 'EditCustomer.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final Color primaryColor = const Color(0xFFE76F51);

  List<Map<String, String>> allCustomers = [
    {
      'name': 'Budi',
      'email': 'budi@email.com',
      'phone': '08123456789',
      'address': 'Jl. Mawar No. 123',
    },
    {
      'name': 'Sari',
      'email': 'sari@email.com',
      'phone': '08198765432',
      'address': 'Jl. Melati No. 45',
    },
  ];

  List<Map<String, String>> displayedCustomers = [];
  String searchQuery = '';

  final Set<int> selectedIndexes = {};
  bool isSelecting = false;

  @override
  void initState() {
    super.initState();
    _searchCustomers('');
  }

  void _searchCustomers(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      if (query.isEmpty) {
        displayedCustomers = List.from(allCustomers);
      } else {
        displayedCustomers =
            allCustomers.where((customer) {
              return (customer['name'] ?? '').toLowerCase().contains(
                    searchQuery,
                  ) ||
                  (customer['email'] ?? '').toLowerCase().contains(searchQuery);
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

  void _hapusPelangganTerpilih() {
    setState(() {
      allCustomers = [
        for (int i = 0; i < allCustomers.length; i++)
          if (!selectedIndexes.contains(i)) allCustomers[i],
      ];
      _searchCustomers(searchQuery);
      selectedIndexes.clear();
      isSelecting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pelanggan yang dipilih telah dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSelecting
              ? '${selectedIndexes.length} dipilih'
              : 'Daftar Pelanggan',
          style: const TextStyle(color: Colors.white),
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
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchCustomers,
              decoration: InputDecoration(
                labelText: 'Cari Pelanggan...',
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
                displayedCustomers.isEmpty
                    ? const Center(child: Text('Belum ada pelanggan'))
                    : ListView.builder(
                      itemCount: displayedCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = displayedCustomers[index];
                        final originalIndex = allCustomers.indexOf(customer);
                        final isSelected = selectedIndexes.contains(
                          originalIndex,
                        );

                        return GestureDetector(
                          onLongPress: () => _startSelectMode(originalIndex),
                          onTap: () async {
                            if (isSelecting) {
                              _toggleSelect(originalIndex);
                            } else {
                              final updatedCustomer = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditCustomerPage(
                                        name: customer['name'] ?? '',
                                        email: customer['email'] ?? '',
                                        phone: customer['phone'] ?? '',
                                        address: customer['address'] ?? '',
                                      ),
                                ),
                              );

                              if (updatedCustomer != null &&
                                  updatedCustomer is Map<String, String>) {
                                setState(() {
                                  allCustomers[originalIndex] = updatedCustomer;
                                  _searchCustomers(searchQuery);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pelanggan diperbarui!'),
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
                                          customer['name'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          customer['phone'] ?? '',
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
                                      Icons.person,
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
                onPressed: _hapusPelangganTerpilih,
                backgroundColor: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              )
              : FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () async {
                  final newCustomer = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCustomerPage(),
                    ),
                  );

                  if (newCustomer != null &&
                      newCustomer is Map<String, String>) {
                    setState(() {
                      allCustomers.add(newCustomer);
                      _searchCustomers(searchQuery);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pelanggan ditambahkan!')),
                    );
                  }
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
    );
  }
}

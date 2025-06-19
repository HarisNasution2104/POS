import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'CheckoutPage.dart';
import '../BarcodeScannerPage.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> barangList = [];
  List<Map<String, dynamic>> barangDitambahkan = [];
  int totalBarangDitambahkan = 0;

  String _searchQuery = '';
  String _sortBy = 'nama';
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _generateDummyBarang();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _generateDummyBarang() {
    barangList.clear();
    for (int i = 1; i <= 20; i++) {
      barangList.add({
        'id': '$i',
        'shop_id': '1',
        'name': 'Barang $i',
        'code': 'BRG$i',
        'quantity': i * 5,
        'price_buy': 10000,
        'price_sell': 15000 + (i * 1000),
        'price': 15000 + (i * 1000),
      });
    }
  }

  List<Map<String, dynamic>> get filteredBarangList {
    List<Map<String, dynamic>> list = barangList.where((item) {
      final name = item['name'].toString().toLowerCase();
      final code = item['code'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || code.contains(query);
    }).toList();

    list.sort((a, b) {
      switch (_sortBy) {
        case 'harga':
          return (a['price_sell'] as int).compareTo(b['price_sell'] as int);
        case 'stok':
          return (a['quantity'] as int).compareTo(b['quantity'] as int);
        case 'nama':
        default:
          return (a['name'] as String).compareTo(b['name'] as String);
      }
    });

    return list;
  }

  void _tambahBarangKePesanan(Map<String, dynamic> data) {
    setState(() {
      final index = barangDitambahkan.indexWhere((b) => b['code'] == data['code']);
      if (index != -1) {
        barangDitambahkan[index]['quantity'] += 1;
      } else {
        barangDitambahkan.add({...data, 'quantity': 1});
      }
      totalBarangDitambahkan = barangDitambahkan.fold(
        0,
        (sum, item) => sum + (item['quantity'] as int),
      );
    });
  }

  void _runParabolicAnimation(String namaBarang) {
    final overlay = Overlay.of(context);
    final RenderBox targetBox = _cartKey.currentContext!.findRenderObject() as RenderBox;
    final Size screenSize = MediaQuery.of(context).size;
    final start = Offset(screenSize.width / 2, screenSize.height / 2);
    final end = targetBox.localToGlobal(Offset.zero);

    late OverlayEntry entry;
    AnimationController controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Animation<double> animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    final String inisial = namaBarang.isNotEmpty ? namaBarang[0].toUpperCase() : '?';

    entry = OverlayEntry(
      builder: (_) {
        return AnimatedBuilder(
          animation: animation,
          builder: (_, __) {
            final t = animation.value;
            final x = start.dx + (end.dx - start.dx) * t;
            final y = start.dy + (end.dy - start.dy) * t - 100 * t * (1 - t);

            return Positioned(
              left: x,
              top: y,
              child: CircleAvatar(
                backgroundColor: const Color(0xFFE76F51),
                radius: 16,
                child: Text(
                  inisial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(entry);
    controller.forward().whenComplete(() {
      entry.remove();
      controller.dispose();
    });
  }
  void _showSortFilterOptions(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx + 1, offset.dy + 1),
      items: const [
        PopupMenuItem(value: 'nama', child: Text('Sort by Nama')),
        PopupMenuItem(value: 'harga', child: Text('Sort by Harga')),
        PopupMenuItem(value: 'stok', child: Text('Sort by Stok')),
      ],
    );

    if (selected != null) {
      setState(() {
        _sortBy = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    const mainColor = Color(0xFFE76F51);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Penjualan', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowUpShortWide, color: mainColor),
                  onPressed: () {
                    RenderBox renderBox = context.findRenderObject() as RenderBox;
                    Offset offset = renderBox.localToGlobal(Offset.zero);
                    _showSortFilterOptions(context, Offset(offset.dx + 35, offset.dy + 125));
                  },
                ),
                Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari Barang...',
                prefixIcon: const Icon(Icons.search, color: mainColor),
                suffixIcon: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.barcode, color: mainColor),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BarcodeScannerPage(),
                      ),
                    );
                    if (result != null) {
                      _searchController.text = result;
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: mainColor),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredBarangList.length,
              itemBuilder: (context, index) {
                final data = filteredBarangList[index];
                final price = data['price_sell'] as int;
                final stock = data['quantity'] as int;
final isDitambahkan = barangDitambahkan.any((item) => item['code'] == data['code']);
                return GestureDetector(
                  onTap: () {
                    _runParabolicAnimation(data['name']);
                    _tambahBarangKePesanan(data);
                  },
                  child: Card(
                    color: isDitambahkan ? Colors.orange[100] : Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$stock',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data['code'], style: const TextStyle(color: Colors.grey)),
                              Text(currencyFormat.format(price), style: const TextStyle(color: Colors.grey)),
                            ],
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
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            key: _cartKey,
            backgroundColor: mainColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutPage(barangDitambahkan: barangDitambahkan),
                ),
              );
            },
            child: const Icon(FontAwesomeIcons.bagShopping, color: Colors.white),
          ),
          if (totalBarangDitambahkan > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Text(
                  totalBarangDitambahkan.toString(),
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

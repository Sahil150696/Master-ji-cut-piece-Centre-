import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MasterJiApp());

const navy = Color(0xFF173B72);
const gold = Color(0xFFC49A42);

class MasterJiApp extends StatelessWidget {
  const MasterJiApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Master Ji Cut Piece Centre',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: navy, brightness: Brightness.light),
          scaffoldBackgroundColor: const Color(0xFFF6F7FA),
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: navy, elevation: 0),
          cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
          inputDecorationTheme: InputDecorationTheme(
            filled: true, fillColor: const Color(0xFFF4F6F9),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        home: const BusinessHub(),
      );
}

class FabricProduct {
  FabricProduct({required this.name, required this.category, required this.description, required this.topM, required this.bottomM, this.wholesalePrice = 0, this.retailPrice = 0, this.stock = 0, this.image = 'assets/products/1001434370.jpg'});
  final String name, category, description, image;
  final double topM, bottomM;
  double wholesalePrice, retailPrice;
  int stock;
}

class BusinessHub extends StatefulWidget {
  const BusinessHub({super.key});
  @override
  State<BusinessHub> createState() => _BusinessHubState();
}

class _BusinessHubState extends State<BusinessHub> {
  int index = 0;
  String role = 'Owner';
  String orderFilter = 'All';
  final products = <FabricProduct>[
    FabricProduct(name: 'Muslin Cotton + Rayon Set', category: 'Dress Material', description: 'Printed muslin cotton top with rayon bottom', topM: 2.25, bottomM: 2.25, image: 'assets/products/1001434370.jpg'),
  ];
  final money = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final pages = [dashboard(), productPage(), ordersPage(), staffPage(), reportsPage()];
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.storefront, color: Colors.white)),
          const SizedBox(width: 10),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MASTER JI', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1, fontSize: 15)), Text('CUT PIECE CENTRE', style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: gold, fontWeight: FontWeight.w800))])),
        ]),
        actions: [PopupMenuButton<String>(initialValue: role, onSelected: (v) => setState(() => role = v), itemBuilder: (_) => const [PopupMenuItem(value: 'Owner', child: Text('Owner access')), PopupMenuItem(value: 'Staff', child: Text('Staff access'))], child: Padding(padding: const EdgeInsets.only(right: 16), child: Chip(avatar: Icon(role == 'Owner' ? Icons.admin_panel_settings : Icons.badge, size: 16), label: Text(role))))],
      ),
      body: SafeArea(child: pages[index]),
      bottomNavigationBar: NavigationBar(selectedIndex: index, onDestinationSelected: (v) => setState(() => index = v), destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
        NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), selectedIcon: Icon(Icons.shopping_bag), label: 'Orders'),
        NavigationDestination(icon: Icon(Icons.groups_outlined), selectedIcon: Icon(Icons.groups), label: 'Staff'),
        NavigationDestination(icon: Icon(Icons.bar_chart_outlined), selectedIcon: Icon(Icons.bar_chart), label: 'Reports'),
      ]),
    );
  }

  Widget heading(String title, {String? subtitle, Widget? trailing}) => Padding(padding: const EdgeInsets.fromLTRB(16, 18, 16, 10), child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: navy)), if (subtitle != null) Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))])), if (trailing != null) trailing]));

  Widget dashboard() => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
    Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [navy, Color(0xFF28538F)]), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('BUSINESS HUB', style: TextStyle(color: Color(0xFFD9E6FA), letterSpacing: 2, fontSize: 11, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Good business\nstarts here.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.15, fontWeight: FontWeight.w800)), const SizedBox(height: 12), Row(children: [const Icon(Icons.store, color: gold, size: 17), const SizedBox(width: 6), Text('Wholesale + Retail', style: TextStyle(color: Colors.white.withOpacity(.9), fontWeight: FontWeight.w600))])])),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.7, children: [metric('Products', '${products.length}', Icons.inventory_2_outlined), metric('Orders', '0', Icons.shopping_bag_outlined), metric('Customers', '0', Icons.people_outline), metric('Today sales', '₹0', Icons.currency_rupee)])),
    heading('Quick actions'),
    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Expanded(child: FilledButton.icon(onPressed: () { setState(() => index = 1); addProduct(); }, icon: const Icon(Icons.add), label: const Text('Add product'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: () => setState(() => index = 2), icon: const Icon(Icons.receipt_long), label: const Text('View orders')))])),
    heading('Business overview', subtitle: 'Your connected business workspace'),
    ...[['Product catalogue', 'Manage photos, fabric details and prices', Icons.photo_library_outlined], ['Inventory', 'Track available stock and low-stock items', Icons.warehouse_outlined], ['Wholesale & retail', 'Maintain separate customer prices', Icons.sell_outlined], ['Staff permissions', 'Give each team member the right access', Icons.admin_panel_settings_outlined]].map((e) => Card(margin: const EdgeInsets.fromLTRB(16, 0, 16, 9), child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFFEAF0F9), child: Icon(e[2] as IconData, color: navy)), title: Text(e[0] as String, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(e[1] as String, style: const TextStyle(fontSize: 12)), trailing: const Icon(Icons.chevron_right)))),
    const Padding(padding: EdgeInsets.all(16), child: Text('Demo workspace: figures are placeholders until a live database and order/payment services are connected.', style: TextStyle(fontSize: 11, color: Colors.grey))),
  ]);

  Widget metric(String label, String value, IconData icon) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: navy), Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: navy)), Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))])));

  Widget productPage() => ListView(children: [heading('Product catalogue', subtitle: '${products.length} products in this demo', trailing: FilledButton.icon(onPressed: addProduct, icon: const Icon(Icons.add, size: 18), label: const Text('Add'))), ...products.map((p) => Card(margin: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(18)), child: Image.asset(p.image, height: 190, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 150, color: Colors.grey.shade200, child: const Icon(Icons.image, size: 50)))), Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)), Text(p.category, style: const TextStyle(color: gold, fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(p.description), const SizedBox(height: 8), Text('Top: ${p.topM} m  •  Bottom: ${p.bottomM} m  •  Total: ${p.topM + p.bottomM} m', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)), const Divider(), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Wholesale: ${money.format(p.wholesalePrice)}'), Text('Retail: ${money.format(p.retailPrice)}')]), Text('Stock: ${p.stock} pieces', style: const TextStyle(color: Colors.grey, fontSize: 12))]))]))]);

  Future<void> addProduct() async {
    final name = TextEditingController(); final cat = TextEditingController(text: 'Dress Material'); final top = TextEditingController(text: '2.25'); final bottom = TextEditingController(text: '2.25'); final wholesale = TextEditingController(); final retail = TextEditingController(); final stock = TextEditingController();
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Add fabric product'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [field(name, 'Product name'), field(cat, 'Category'), Row(children: [Expanded(child: field(top, 'Top metres', numeric: true)), const SizedBox(width: 8), Expanded(child: field(bottom, 'Bottom metres', numeric: true))]), field(wholesale, 'Wholesale price ₹', numeric: true), field(retail, 'Retail price ₹', numeric: true), field(stock, 'Stock pieces', numeric: true)])), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save product'))]));
    if (ok == true && name.text.trim().isNotEmpty && mounted) setState(() => products.add(FabricProduct(name: name.text.trim(), category: cat.text.trim(), description: 'Fabric product', topM: double.tryParse(top.text) ?? 0, bottomM: double.tryParse(bottom.text) ?? 0, wholesalePrice: double.tryParse(wholesale.text) ?? 0, retailPrice: double.tryParse(retail.text) ?? 0, stock: int.tryParse(stock.text) ?? 0, image: 'assets/products/1001434360.jpg')));
  }

  Widget field(TextEditingController c, String label, {bool numeric = false}) => Padding(padding: const EdgeInsets.only(bottom: 9), child: TextField(controller: c, keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text, decoration: InputDecoration(labelText: label, isDense: true)));

  Widget ordersPage() => ListView(padding: const EdgeInsets.all(16), children: [heading('Order management', subtitle: 'Wholesale and retail orders'), Wrap(spacing: 7, children: ['All', 'New', 'Packed', 'Shipped'].map((s) => ChoiceChip(label: Text(s), selected: orderFilter == s, onSelected: (_) => setState(() => orderFilter = s)).toList()), const SizedBox(height: 22), Container(padding: const EdgeInsets.all(26), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: const Column(children: [Icon(Icons.inventory_2_outlined, size: 46, color: navy), SizedBox(height: 10), Text('No orders yet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)), Text('New customer orders will appear here after the store is connected.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12))])), heading('Order workflow'), ...['New order received', 'Payment verified', 'Fabric packed', 'Dispatched', 'Delivered'].asMap().entries.map((e) => ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFFEAF0F9), child: Text('${e.key + 1}', style: const TextStyle(color: navy))), title: Text(e.value)))]);

  Widget staffPage() => ListView(padding: const EdgeInsets.all(16), children: [heading('Staff & access', subtitle: 'Role-based access overview'), Card(child: Column(children: const [ListTile(leading: CircleAvatar(child: Icon(Icons.admin_panel_settings)), title: Text('Owner'), subtitle: Text('Full control: prices, reports, staff and settings'), trailing: Icon(Icons.verified, color: Colors.green)), Divider(height: 1), ListTile(leading: CircleAvatar(child: Icon(Icons.badge)), title: Text('Sales staff'), subtitle: Text('Orders and customer enquiries'), trailing: Icon(Icons.lock_outline)), Divider(height: 1), ListTile(leading: CircleAvatar(child: Icon(Icons.warehouse)), title: Text('Inventory staff'), subtitle: Text('Stock and product updates, as authorized'), trailing: Icon(Icons.lock_outline))])), const SizedBox(height: 12), const Text('Production setup will create individual staff logins and enforce permissions on the server. This demo role selector is not secure authentication.', style: TextStyle(color: Colors.grey, fontSize: 12))]);

  Widget reportsPage() => ListView(padding: const EdgeInsets.all(16), children: [heading('Sales & reports', subtitle: 'Wholesale and retail performance'), Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Recorded revenue', style: TextStyle(color: Colors.grey)), const Text('₹0', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: navy)), const Divider(height: 28), reportLine('Wholesale sales', '₹0'), reportLine('Retail sales', '₹0'), reportLine('Expenses', '₹0'), reportLine('Estimated profit', '₹0')])), const SizedBox(height: 12), const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Reports will be calculated from real orders, payments, purchases and expenses after backend integration.', style: TextStyle(color: Colors.grey, fontSize: 12))))]);

  Widget reportLine(String label, String value) => Padding(padding: const EdgeInsets.symmetric(vertical: 7), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.w700))]));
}

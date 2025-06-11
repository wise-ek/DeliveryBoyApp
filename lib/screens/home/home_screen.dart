import 'package:boyapp/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/login_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../models/order_model.dart';
import '../../providers/theme_provider.dart';
import 'widgets/filter_button.dart';
import 'widgets/order_card.dart';
import 'widgets/search_bar.dart';
import '../order/order_details_screen.dart';


class HomeScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String uid;

  const HomeScreen({super.key, required this.name, required this.phoneNumber, required this.uid});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedStatus = 'All';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Row(
                children: [
                  Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: Colors.white,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
              final loginProvider = context.read<LoginProvider>();
              await loginProvider.updatePhoneNumber(widget.phoneNumber);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    name: loginProvider.name,
                    phoneNumber: loginProvider.phoneNumber,
                    uid: loginProvider.uid,
                  ),
                ),
              );
            },
          ),

        ],
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,

      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          final filteredOrders = provider.filterOrders(
            selectedStatus,
            searchController.text.trim(),
          );

          return Column(
            children: [
              SearchBarWidget(
                controller: searchController,
                onSearch: () => setState(() {}),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterButton(
                      label: "All",
                      count: provider.allCount,
                      isSelected: selectedStatus == "All",
                      onTap: () {
                        setState(() {
                          selectedStatus = "All";
                          searchController.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      label: "Pending",
                      count: provider.pendingCount,
                      isSelected: selectedStatus == "Pending",
                      onTap: () {
                        setState(() {
                          selectedStatus = "Pending";
                          searchController.clear();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterButton(
                      label: "Delivered",
                      count: provider.deliveredCount,
                      isSelected: selectedStatus == "Delivered",
                      onTap: () {
                        setState(() {
                          selectedStatus = "Delivered";
                          searchController.clear();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: provider.orders.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredOrders.isEmpty
                    ? const Center(child: Text("No orders found"))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) => OrderCard(
                    order: filteredOrders[index],
                    index: index,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

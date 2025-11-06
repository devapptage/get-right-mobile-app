import 'package:flutter/material.dart';
import 'package:get_right/widgets/common/empty_state.dart';

/// Marketplace screen - browse trainer programs
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search programs
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Filter programs
            },
          ),
        ],
      ),
      body: const EmptyState(icon: Icons.school, title: 'Browse Programs', subtitle: 'Discover fitness programs from certified trainers and influencers'),
    );
  }
}

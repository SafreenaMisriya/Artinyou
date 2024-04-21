
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:flutter/material.dart';

class TabBarViewScreen extends StatelessWidget {
  const TabBarViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 7,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Colors.red,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text('All'),
              ),
              Tab(
                child: Text('Creative'),
              ),
              Tab(
                child: Text('Fantasy'),
              ),
              Tab(
                child: Text('Photography'),
              ),
              Tab(
                child: Text('Wallpapers'),
              ),
              Tab(
                child: Text('3D Art'),
              ),
              Tab(
                child: Text('Craft'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                GridViewScreen(),
                GridViewScreen(),
                GridViewScreen(),
                GridViewScreen(),
                GridViewScreen(),
                GridViewScreen(),
                GridViewScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

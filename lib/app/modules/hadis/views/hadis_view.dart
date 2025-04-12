import 'package:flutter/material.dart';
import 'package:quran/app/views/base_view.dart';

class HadisView extends BaseView {
  const HadisView({super.key});

  @override
  Widget get body => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assalamu\'alaikum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Hadis 1'),
                  Tab(text: 'Hadis 2'),
                  Tab(text: 'Hadis 3'),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: TabBarView(
                    children: [
                      const Center(child: Text('Hadis Tab 1')),
                      const Center(child: Text('Hadis Tab 2')),
                      const Center(child: Text('Hadis Tab 3')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

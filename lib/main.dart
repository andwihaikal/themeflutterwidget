import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    MovieHomePage(),
    ExplorePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: pages[selectedIndex],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.only(bottom: 12, top: 4),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          onTap: (i) => setState(() => selectedIndex = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded),
              label: "Explore",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}

class MovieData {
  static const nowPlaying = [
    {"img": "images/Batgirl.jpeg", "title": "The Batgirl"},
    {"img": "images/BATMAN.jpeg", "title": "The Batman"},
    {"img": "images/batmanart.jpeg", "title": "The Batman Part 2"},
  ];

  static const moviesHorizontal = [
    {"img": "images/Batgirl.jpeg", "title": "The Batgirl"},
    {"img": "images/BATMAN.jpeg", "title": "The Batman"},
    {"img": "images/batmanart.jpeg", "title": "The Batman Part 2"},
    {"img": "images/Batgirl.jpeg", "title": "The Batgirl"},
  ];
}

class MovieHomePage extends StatelessWidget {
  const MovieHomePage({super.key});

  Widget buildMovieRow(String label, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: MovieData.moviesHorizontal.length,
            itemBuilder: (context, index) {
              var movie = MovieData.moviesHorizontal[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => DetailPage(
                        img: movie["img"]!,
                        title: movie["title"]!,
                      ),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: (_, animation, __, child) =>
                          FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },

                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Hero(
                            tag: movie["img"]!,
                            child: Image.asset(
                              movie["img"]!,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        movie["title"]!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
              ),
              items: MovieData.nowPlaying.map((movie) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          img: movie["img"]!,
                          title: movie["title"]!,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Hero(
                        tag: movie["img"]!,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            movie["img"]!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 16,
                        child: Text(
                          movie["title"]!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            buildMovieRow("Trending", context),
            buildMovieRow("Popular", context),
            buildMovieRow("Top Rated", context),
          ],
        ),
      ),
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Explore Page", style: TextStyle(fontSize: 26)),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Settings Page", style: TextStyle(fontSize: 26)),
    );
  }
}

// ✅ DETAIL PAGE
class DetailPage extends StatelessWidget {
  final String img;
  final String title;

  const DetailPage({super.key, required this.img, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.redAccent),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Hero(
            tag: img,
            child: Image.asset(img, height: 350, fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          Text(
            "Detail Film Akan Ditambahkan...",
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

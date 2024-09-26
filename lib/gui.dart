import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ChalkTalkApp());
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ChalkTalkApp extends StatefulWidget {
  const ChalkTalkApp({super.key});

  @override
  State<ChalkTalkApp> createState() => _ChalkTalkAppState();
}

class _ChalkTalkAppState extends State<ChalkTalkApp> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showBottomSheet();
      }
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'This is a scalable bottom sheet',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    // Add more widgets here
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4.0,
          flexibleSpace: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.scale(
                      scale: 0.8,
                      child: SizedBox(
                        height: 80,
                        child: Image.network(
                          'https://chalktalk.world/wp-content/uploads/2023/03/logo-chalk-1.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Transform.scale(
                          scale: 0.8,
                          child: const Text(
                            'Learning Beyond Borders',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Talk to Chalk Talk Chat Bot...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          print('Send message');
                        },
                        icon: const Icon(Icons.send, color: Colors.green, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMentorsSection(),
            _buildMentorsList(),
            const Divider(height: 20, thickness: 2, color: Colors.green),
            const Center(child: Text('Learning Made Easy')),
            const Divider(height: 20, thickness: 2, color: Colors.green),
            _buildSessionsSection(),
            _buildSessionsCarousel(),
            const Divider(height: 20, thickness: 2, color: Colors.green),
            const Center(child: Text('Learn like never before')),
            const Divider(height: 20, thickness: 2, color: Colors.green),
            _buildCategoriesSection(),
            _buildCategoriesCarousel(),
            const Divider(height: 20, thickness: 2, color: Colors.green),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.explore, size: 18, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Learn About Us'),
                  SizedBox(width: 8),
                  Icon(Icons.explore, size: 18, color: Colors.green),
                ],
              ),
            ),
            const Divider(height: 20, thickness: 2, color: Colors.green),
             AboutSection(
              title: 'Join us on our website "chalktalk.world"',
              description: 'Here you can find ways to experience',
              imageUrl: 'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Positioned(
          bottom: 40,
          right: 20,
          child: SizedBox(
            width: 200,
            height: 40,
            child: FloatingActionButton(
              onPressed: () {
                // Define your button action here
              },
              child: const Text(
                'Login or Register for Free!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.yellow,
                ),
              ),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, {required VoidCallback onViewAllPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAllPressed,
            child: const Text('View All >'),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorsList() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: _getMentorImageUrl(index),
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getMentorName(index),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

 Widget _buildSessionsCarousel() {
  final List<String> sessionTitles = [
    'Introduction to Flutter',
    'Dart for Beginners',
    'Building Responsive UIs',
    'State Management in Flutter',
    'Advanced Flutter Techniques',
  ];

  final List<String> sessionImages = [
    'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
    'https://i.pinimg.com/236x/63/af/a1/63afa1ac46b69791d44aaefd4563dea7.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8assQNyFfabFEQmRwqdopOANsbzJtXRdNSkKIDc7WmfFdAG7wvXvAV7vzPWL8XTtwxyU&usqp=CAU',
    'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  final List<String> sessionDescriptions = [
    'Learn Flutter basics for cross-platform app development.',
    'Get started with Dart, the language behind Flutter.',
    'Create adaptive layouts for different screen sizes.',
    'Manage your app’s state with Provider or BLoC.',
    'Explore advanced topics like animations and custom widgets.',
  ];

  return Container(
    height: 300, // Set a fixed height for the carousel
    child: CarouselSlider.builder(
      itemCount: sessionTitles.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          height: 400,
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: sessionImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150, // Fixed height for images
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sessionTitles[index],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sessionDescriptions[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Session Time: 10:00 AM - 11:00 AM',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Session Duration: 1 Hour',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Available Seats: 5',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      ElevatedButton(
                        onPressed: () {
                          _launchURL('https://example.com/session/${index}');
                        },
                        child: const Text('Join Session'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 300, // Maintain a height for carousel
        enlargeCenterPage: true,
        autoPlay: true,
      ),
    ),
  );
}



  Widget _buildCategoriesCarousel() {
    final List<String> categoryImages = [
      'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
      'https://i.pinimg.com/236x/63/af/a1/63afa1ac46b69791d44aaefd4563dea7.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8assQNyFfabFEQmRwqdopOANsbzJtXRdNSkKIDc7WmfFdAG7wvXvAV7vzPWL8XTtwxyU&usqp=CAU',
      'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ];

    return CarouselSlider.builder(
      itemCount: categoryImages.length,
      itemBuilder: (context, index, realIndex) {
        return GestureDetector(
          onTap: () {
            // Define your category action here
          },
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: categoryImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
    );
  }

  Widget _buildMentorsSection() {
    return _buildSectionTitle('Mentors', onViewAllPressed: () {
      // Handle view all mentors action
    });
  }

  Widget _buildSessionsSection() {
    return _buildSectionTitle('Sessions', onViewAllPressed: () {
      // Handle view all sessions action
    });
  }

  Widget _buildCategoriesSection() {
    return _buildSectionTitle('Categories', onViewAllPressed: () {
      // Handle view all categories action
    });
  }

  String _getMentorImageUrl(int index) {
    final List<String> mentorImages = [
      'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
      'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
      'https://i.pinimg.com/236x/63/af/a1/63afa1ac46b69791d44aaefd4563dea7.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8assQNyFfabFEQmRwqdopOANsbzJtXRdNSkKIDc7WmfFdAG7wvXvAV7vzPWL8XTtwxyU&usqp=CAU',
      'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    ];
    return mentorImages[index % mentorImages.length];
  }

  String _getMentorName(int index) {
    final List<String> mentorNames = [
      'John Doe',
      'Jane Smith',
      'Emily Johnson',
      'Michael Brown',
      'Sarah Davis',
    ];
    return mentorNames[index % mentorNames.length];
  }
}

class AboutSection extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  AboutSection({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  void _launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
        
        ],
      ),
    );
  }
}

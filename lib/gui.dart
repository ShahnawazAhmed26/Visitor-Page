import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

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
  double _scaleFactor = 1.0;
  late Timer _timer;
  bool _logoVisible = false; // Start with the logo hidden

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showBottomSheet();
      }
    });

    // Auto start the fade-in animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _logoVisible = true; // Show the logo after the delay
      });
    });

    _startScalingAnimation();
  }

  void _startScalingAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _scaleFactor = _scaleFactor == 1.0 ? 1.2 : 1.0; // Toggle between scales
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
  final screenHeight = MediaQuery.of(context).size.height;
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(250),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Colors.transparent, // This can remain as is or be adjusted
      const Color(0xFFD0FFBC), // Updated to use #D0FFBC
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: _logoVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Image.network(
                        'https://chalktalk.world/wp-content/uploads/2023/03/logo-chalk-1.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ColorizeAnimatedTextKit(
                    text: ['Learning Beyond Borders'],
                    colors: [
                      Colors.green.shade200,
                      Colors.green.shade400,
                      Colors.green.shade600,
                      Colors.green.shade800,
                    ],
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: Duration(milliseconds: 200),
                    repeatForever: true,
                    onFinished: null,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Talk to Chalk Talk Chat Bot...',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    body: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
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
                title: 'Join us on our website',
                description: 'Here you can find ways to experience',
                imageUrl: 'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
                websiteUrl: 'https://chalktalk.world/', // Add "https://" to the URL
              ),
            ],
          ),
          Positioned(
            right: 20,
            bottom: 40,
            child: ElevatedButton(
              onPressed: () {
                // Define login/register action here
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.login_outlined, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Login / Register',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xff6a9f3e),
                ),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                elevation: MaterialStateProperty.all(8),
                shadowColor: MaterialStateProperty.all(Colors.black45),
              ),
            ),
          ),
        ],
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
    'Kickstart your journey with Flutter by learning its essential components and widgets.',
    'Master the fundamentals of Dart, the language behind Flutter, to build efficient applications.',
    'Learn to create stunning, adaptive UIs that work seamlessly across devices.',
    'Understand various state management strategies to maintain your app’s data effectively.',
    'Explore advanced techniques including custom animations and performance enhancements.',
  ];

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: CarouselSlider.builder(
      itemCount: sessionTitles.length,
      itemBuilder: (context, index, realIndex) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double width = MediaQuery.of(context).size.width * 0.8;
            return Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: CachedNetworkImage(
                        imageUrl: sessionImages[index],
                        fit: BoxFit.cover,
                        width: width,
                        height: 150,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.grey[100]!],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sessionTitles[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            sessionDescriptions[index],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          _buildSessionDetails('calendar_today', 'Starting From 13th May 2024'),
                          SizedBox(height: 4),
                          _buildSessionDetails('money', 'Charges: 50 \$ per month'),
                          SizedBox(height: 4),
                          _buildSessionDetails('access_time', 'Timings: 10:00 AM - 11:00 AM'),
                          SizedBox(height: 4),
                          _buildSessionDetails('assignment', 'Course lectures will be provided'),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      options: CarouselOptions(
        height: 520,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 2.0,
      ),
    ),
  );
}

Widget _buildSessionDetails(String iconName, String detail) {
  return Row(
    children: [
      Icon(Icons.person, color: Colors.grey), // Replace iconName with the correct variable
      SizedBox(width: 4),
      Text(detail, style: TextStyle(color: Colors.grey)),
    ],
  );
}



Widget _buildCategoriesCarousel() {
  final List<String> categoryTitles = [
    'Mobile Development',
    'Web Development',
    'AI & Machine Learning',
    'Cloud Computing',
    'Cybersecurity',
  ];

  final List<String> categoryImages = [
    'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg',
    'https://i.pinimg.com/236x/63/af/a1/63afa1ac46b69791d44aaefd4563dea7.jpg',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8assQNyFfabFEQmRwqdopOANsbzJtXRdNSkKIDc7WmfFdAG7wvXvAV7vzPWL8XTtwxyU&usqp=CAU',
    'https://images.pexels.com/photos/3184642/pexels-photo-3184642.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  return Container(
    height: 250, // Adjust the height to accommodate text below the images
    child: CarouselSlider.builder(
      itemCount: categoryImages.length,
      itemBuilder: (context, index, realIndex) {
        return Column(
          children: [
            GestureDetector(
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
            ),
            const SizedBox(height: 8),
            Text(
              categoryTitles[index],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        height: 300, // Maintained height for carousel
        enlargeCenterPage: true,
        autoPlay: true,
      ),
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
  final String websiteUrl;

  const AboutSection({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.websiteUrl,
  }) : super(key: key);

 void _launchURL(String url) async {
  final Uri _url = Uri.parse(url);
  if (await canLaunchUrl(_url)) {
    await launchUrl(_url);
  } else {
    print('Could not launch $url'); // Debugging message
  }
}


  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 40,
                  color: Colors.black54,
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => _launchURL(websiteUrl),
              child: const Text('Visit Website'),
            ),
          ],
        ),
      ),
    ),
  );
}

}
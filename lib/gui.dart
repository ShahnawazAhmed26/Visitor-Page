import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(ChalkTalkApp());
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
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
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
      appBar: AppBar(
        toolbarHeight: 250, // Increased toolbar height for better spacing
        backgroundColor: Colors.white,
        elevation: 4.0,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Row(
                children: [
                  SizedBox(
                    height: 80, // Adjust the height to make the logo bigger
                    child: Image.network(
                      'https://chalktalk.world/wp-content/uploads/2023/03/logo-chalk-1.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 10), // Add some spacing between the image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Learn Beyond Borders',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible, // Ensure text is fully visible
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10), // Add some spacing
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign in Now!',
                      style: TextStyle(color: Colors.blue), // Customize text color
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Space between title and search bar
            SizedBox(
              width: 400, // Set a fixed width for the search bar
              child: TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Talk to our Chat Bot',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Space from the AppBar
        child: ListView.builder(
          itemCount: 5, // Number of session cards
          itemBuilder: (context, index) {
            return CustomCard(
              title: _getInstructorExpertise(index), // Use expertise as title
              description: _getSessionDescription(index),
              image: _getImageUrl(index),
              onTap: () {
                // Handle onTap event
                print('Tapped on session $index');
              },
            );
          },
        ),
      ),
    );
  }

  String _getInstructorExpertise(int index) {
    switch (index) {
      case 0:
        return 'Aisha Khan ';
      case 1:
        return 'Omar Malik  ';
      case 2:
        return 'Fatima Ali  ';
      case 3:
        return 'Bilal Ahmed';
      case 4:
        return 'Sara Iqbal';
      default:
        return 'Raza Abbas ';
    }
  }

  String _getSessionDescription(int index) {
    switch (index) {
      case 0:
        return ' Expert in Creative Writing';
      case 1:
        return 'Data Science Specialist';
      case 2:
        return 'Digital Marketing Strategist.';
      case 3:
        return 'Graphic Design Instructor.';
      case 4:
        return 'Public Speaking Coach';
      default:
        return 'Expert in Various Fields';
    }
  }

  String _getImageUrl(int index) {
    switch (index) {
      case 0:
        return 'https://i.pinimg.com/736x/12/1d/ca/121dca8c507ea2bc870e345b8d9aeff1.jpg';
      case 1:
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR8assQNyFfabFEQmRwqdopOANsbzJtXRdNSkKIDc7WmfFdAG7wvXvAV7vzPWL8XTtwxyU&usqp=CAU';
      case 2:
        return 'https://i.pinimg.com/236x/63/af/a1/63afa1ac46b69791d44aaefd4563dea7.jpg';
      case 3:
        return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdSMd8rd0RKoEU8rEKDNxi7KXbFGQsmNs-_A33nWq-Dy_ftfF7P9VkE3XTZ0drjRxxHcQ&usqp=CAU';
      case 4:
        return 'https://images.pexels.com/photos/3820164/pexels-photo-3820164.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      default:
        return 'https://images.pexels.com/photos/1624496/pexels-photo-1624496.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    }
  }
}

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;

  const CustomCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color.fromARGB(255, 230, 230, 250), // Light lavender
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Increased padding for better spacing
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    height: 120, // Adjusted height for balance
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15), // Increased space between image and text
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            colors: [Colors.blueAccent, Colors.blue], // Gradient for the title
                          ).createShader(bounds);
                        },
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // Increased font size for visibility
                            color: Colors.white, // White for better visibility against gradient
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: onTap,
                        child: const Text("Join Now"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

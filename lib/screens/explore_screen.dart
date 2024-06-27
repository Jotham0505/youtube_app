import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  final List<String>  uploadedVideos;

  const ExploreScreen({required this.uploadedVideos});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late List<String> _uploadedVideos;

  @override
  void initState() {
    super.initState();
    _uploadedVideos = widget.uploadedVideos;
  }

  void addVideo(String videoUrl) {
    setState(() {
      _uploadedVideos.add(videoUrl);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
      ),
      body: ListView.builder(
        itemCount: _uploadedVideos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Video ${index + 1}'),
            subtitle: Text(_uploadedVideos[index]),
          );
        },
      ),
    );
  }
}



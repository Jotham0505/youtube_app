class User {
  final String username;
  final String profileImageUrl;
  final String subscribers;

  const User({
    required this.username,
    required this.profileImageUrl,
    required this.subscribers,
  });
}

const User currentUser = User(
  username: 'Marcus Ng',
  profileImageUrl:
      'https://yt3.ggpht.com/ytc/AAUvwniE2k5PgFu9yr4sBVEs9jdpdILdMc7ruiPw59DpS0k=s88-c-k-c0x00ffffff-no-rj',
  subscribers: '100K',
);

class Video {
  final String id;
  final User author;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final DateTime timestamp;
  final String viewCount;
  final String likes;
  final String dislikes;
  final String videoUrl;

  const Video({
    required this.videoUrl,
    required this.id,
    required this.author,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.timestamp,
    required this.viewCount,
    required this.likes,
    required this.dislikes,
  });
}

final List<Video> videos = [
  Video(
    id: 'x606y4QWrxo',
    author: currentUser,
    title: 'Big Buck Bunny',
    thumbnailUrl: 'https://promincproductions.com/blog/wp-content/uploads/2015/06/0.jpg',
    duration: '8:20',
    timestamp: DateTime(2021, 3, 20),
    viewCount: '10K',
    likes: '958',
    dislikes: '4', videoUrl: 'https://www.taxmann.com/emailer/images/CompaniesAct.mp4',

  ),
  Video(
    author: currentUser,
    id: 'vrPk6LB9bjo',
    title:
        'Build Flutter Apps Fast with Riverpod, Firebase, Hooks, and Freezed Architecture',
    thumbnailUrl: 'https://i.ytimg.com/vi/r0VgFZv7o0k/mqdefault.jpg',
    duration: '22:06',
    timestamp: DateTime(2021, 2, 26),
    viewCount: '8K',
    likes: '485',
    dislikes: '8', videoUrl: 'https://www.taxmann.com/emailer/images/FEMA.mp4',
  ),
  Video(
    id: 'ilX5hnH8XoI',
    author: currentUser,
    title: 'Flutter Instagram Stories',
    thumbnailUrl: 'https://promincproductions.com/blog/wp-content/uploads/2015/06/3.jpg',
    duration: '10:53',
    timestamp: DateTime(2020, 7, 12),
    viewCount: '18K',
    likes: '1k',
    dislikes: '4', videoUrl: 'https://www.taxmann.com/emailer/images/IBC.mp4',
  ),
];

final List<Video> suggestedVideos = [
  Video(
    id: 'rJKN_880b-M',
    author: currentUser,
    title: 'For Bigger Joyrides',
    thumbnailUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg',
    duration: '1:13:15',
    timestamp: DateTime(2020, 8, 22),
    viewCount: '32K',
    likes: '1.9k',
    dislikes: '7', videoUrl: 'https://www.taxmann.com/emailer/images/Incometax.mp4',
  ),
  Video(
    id: 'HvLb5gdUfDE',
    author: currentUser,
    title: 'Flutter Facebook Clone Responsive UI Tutorial | Web and Mobile',
    thumbnailUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg',
    duration: '1:52:12',
    timestamp: DateTime(2020, 8, 7),
    viewCount: '190K',
    likes: '9.3K',
    dislikes: '45', videoUrl: 'https://www.taxmann.com/emailer/images/GST.mp4',
  ),
  Video(
    id: 'h-igXZCCrrc',
    author: currentUser,
    title: 'Flutter Chat UI Tutorial | Apps From Scratch',
    thumbnailUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg',
    duration: '1:03:58',
    timestamp: DateTime(2019, 10, 17),
    viewCount: '358K',
    likes: '20k',
    dislikes: '85', videoUrl: 'https://www.taxmann.com/emailer/images/Incometax.mp4',
  ),
];

class RandomImage {
  final String url;

  RandomImage({required this.url});

  factory RandomImage.fromJson(Map<String, dynamic> json) {
    return RandomImage(
      url: json['url'] as String,
    );
  }
}
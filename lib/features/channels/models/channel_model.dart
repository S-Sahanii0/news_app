import 'dart:convert';

class Channel {
  final String channelName;
  final String channelImage;
  Channel({
    required this.channelName,
    required this.channelImage,
  });

  Channel copyWith({
    String? channelName,
    String? channelImage,
  }) {
    return Channel(
      channelName: channelName ?? this.channelName,
      channelImage: channelImage ?? this.channelImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channelName': channelName,
      'channelImage': channelImage,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      channelName: map['channelName'],
      channelImage: map['channelImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Channel(channelName: $channelName, channelImage: $channelImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Channel &&
        other.channelName == channelName &&
        other.channelImage == channelImage;
  }

  @override
  int get hashCode => channelName.hashCode ^ channelImage.hashCode;
}

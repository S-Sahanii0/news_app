import 'dart:convert';

class Channel {
  final String channel;
  final String channelImage;
  Channel({
    required this.channel,
    required this.channelImage,
  });

  Channel copyWith({
    String? channel,
    String? channelImage,
  }) {
    return Channel(
      channel: channel ?? this.channel,
      channelImage: channelImage ?? this.channelImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channel': channel,
      'channelImage': channelImage,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      channel: map['channel'],
      channelImage: map['channelImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));

  @override
  String toString() =>
      'Channel(channel: $channel, channelImage: $channelImage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Channel &&
        other.channel == channel &&
        other.channelImage == channelImage;
  }

  @override
  int get hashCode => channel.hashCode ^ channelImage.hashCode;
}

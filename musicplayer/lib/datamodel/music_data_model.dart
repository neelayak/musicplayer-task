class MusicDataModel {
  List<Songlist>? songlist;

  MusicDataModel({this.songlist});

  MusicDataModel.fromJson(Map<String, dynamic> json) {
    if (json['songlist'] != null) {
      songlist = <Songlist>[];
      json['songlist'].forEach((v) {
        songlist!.add(new Songlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.songlist != null) {
      data['songlist'] = this.songlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Songlist {
  String? songName;
  String? songCover;
  String? songArtistname;
  String? songUrl;

  Songlist({this.songName, this.songCover, this.songArtistname, this.songUrl});

  Songlist.fromJson(Map<String, dynamic> json) {
    songName = json['song_name'];
    songCover = json['song_cover'];
    songArtistname = json['song_artistname'];
    songUrl = json['song_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song_name'] = this.songName;
    data['song_cover'] = this.songCover;
    data['song_artistname'] = this.songArtistname;
    data['song_url'] = this.songUrl;
    return data;
  }
}

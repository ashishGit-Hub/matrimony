/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

GalleryModel galleryModelFromJson(String str) => GalleryModel.fromJson(json.decode(str));

String galleryModelToJson(GalleryModel data) => json.encode(data.toJson());

class GalleryModel {
    GalleryModel({
        required this.gid,
        required this.userId,
        required this.imagePath,
    });

    int gid;
    int userId;
    String imagePath;

    factory GalleryModel.fromJson(Map<dynamic, dynamic> json) => GalleryModel(
        gid: json["gid"],
        userId: json["user_id"],
        imagePath: json["image_path"],
    );

    Map<dynamic, dynamic> toJson() => {
        "gid": gid,
        "user_id": userId,
        "image_path": imagePath,
    };
}

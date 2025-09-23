// To parse this JSON data, do
//
//     final inboxListResponse = inboxListResponseFromJson(jsonString);

import 'dart:convert';

InboxListResponse inboxListResponseFromJson(String str) => InboxListResponse.fromJson(json.decode(str));

String inboxListResponseToJson(InboxListResponse data) => json.encode(data.toJson());

class InboxListResponse {
    String message;
    List<Inbox> inbox;
    EgedUser egedUser;
    int status;

    InboxListResponse({
        required this.message,
        required this.inbox,
        required this.egedUser,
        required this.status,
    });

    factory InboxListResponse.fromJson(Map<String, dynamic> json) => InboxListResponse(
        message: json["@message"],
        inbox: List<Inbox>.from(json["@inbox"].map((x) => Inbox.fromJson(x))),
        egedUser: EgedUser.fromJson(json["@eged_user"]),
        status: json["@status"],
    );

    Map<String, dynamic> toJson() => {
        "@message": message,
        "@inbox": List<dynamic>.from(inbox.map((x) => x.toJson())),
        "@eged_user": egedUser.toJson(),
        "@status": status,
    };
}

class EgedUser {
    int id;
    String address;
    String pincode;
    String profileApproved;
    String fcmToken;
    DateTime updatedAt;
    String city;
    String fullName;
    String phoneNumber;
    String image;
    DateTime lastActiveAt;
    DateTime createdAt;

    EgedUser({
        required this.id,
        required this.address,
        required this.pincode,
        required this.profileApproved,
        required this.fcmToken,
        required this.updatedAt,
        required this.city,
        required this.fullName,
        required this.phoneNumber,
        required this.image,
        required this.lastActiveAt,
        required this.createdAt,
    });

    factory EgedUser.fromJson(Map<String, dynamic> json) => EgedUser(
        id: json["id"],
        address: json["address"],
        pincode: json["pincode"],
        profileApproved: json["profile_approved"],
        fcmToken: json["fcm_Token"],
        updatedAt: DateTime.parse(json["updated_at"]),
        city: json["city"],
        fullName: json["full_name"],
        phoneNumber: json["phone_number"],
        image: json["image"],
        lastActiveAt: DateTime.parse(json["last_active_at"]),
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "address": address,
        "pincode": pincode,
        "profile_approved": profileApproved,
        "fcm_Token": fcmToken,
        "updated_at": updatedAt.toIso8601String(),
        "city": city,
        "full_name": fullName,
        "phone_number": phoneNumber,
        "image": image,
        "last_active_at": lastActiveAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
    };
}

class Inbox {
    String conversationId;
    OtherUser otherUser;
    String lastMessage;
    DateTime timestamp;

    Inbox({
        required this.conversationId,
        required this.otherUser,
        required this.lastMessage,
        required this.timestamp,
    });

    factory Inbox.fromJson(Map<String, dynamic> json) => Inbox(
        conversationId: json["conversation_id"],
        otherUser: OtherUser.fromJson(json["other_user"]),
        lastMessage: json["last_message"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "conversation_id": conversationId,
        "other_user": otherUser.toJson(),
        "last_message": lastMessage,
        "timestamp": timestamp.toIso8601String(),
    };
}

class OtherUser {
    int id;
    String name;
    String? profilePick;
    bool isReaded;
    bool senderYou;

    OtherUser({
        required this.id,
        required this.name,
        required this.profilePick,
        required this.isReaded,
        required this.senderYou,
    });

    factory OtherUser.fromJson(Map<String, dynamic> json) => OtherUser(
        id: json["_id"],
        name: json["name"],
        profilePick: json["profilePick"],
        isReaded: json["is_readed"],
        senderYou: json["sender_you"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profilePick": profilePick,
        "is_readed": isReaded,
        "sender_you": senderYou,
    };
}

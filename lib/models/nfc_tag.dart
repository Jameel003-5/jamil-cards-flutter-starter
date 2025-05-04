class NFCTag {
  final String id;
  final String uid;
  final bool isActivated;
  final String? assignedUserId;
  final DateTime? activatedAt;
  final DateTime createdAt;

  NFCTag({
    required this.id,
    required this.uid,
    this.isActivated = false,
    this.assignedUserId,
    this.activatedAt,
    required this.createdAt,
  });

  factory NFCTag.fromJson(Map<String, dynamic> json) {
    return NFCTag(
      id: json['id'],
      uid: json['uid'],
      isActivated: json['isActivated'] ?? false,
      assignedUserId: json['assignedUserId'],
      activatedAt: json['activatedAt'] != null 
          ? DateTime.parse(json['activatedAt']) 
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'isActivated': isActivated,
      'assignedUserId': assignedUserId,
      'activatedAt': activatedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  NFCTag copyWith({
    String? id,
    String? uid,
    bool? isActivated,
    String? assignedUserId,
    DateTime? activatedAt,
    DateTime? createdAt,
  }) {
    return NFCTag(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      isActivated: isActivated ?? this.isActivated,
      assignedUserId: assignedUserId ?? this.assignedUserId,
      activatedAt: activatedAt ?? this.activatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

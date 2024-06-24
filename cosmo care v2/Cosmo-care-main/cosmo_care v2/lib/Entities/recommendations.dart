import 'package:cloud_firestore/cloud_firestore.dart';

class recommendations {
  final String? recommendation;
  final String? username;
  final String? status;

  recommendations({
    this.recommendation,
    this.username,
    this.status,
  });

  factory recommendations.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, {
    SnapshotOptions? options,
  }) {
    final data = snapshot.data();
    return recommendations(
      recommendation: data?['recommendation'],
      username: data?['username'],
      status: data?['status'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      if (recommendation != null) "recommendation": recommendation,
      if (username != null) "username": username,
      if (status != null) "status": status,
    };
  }
}

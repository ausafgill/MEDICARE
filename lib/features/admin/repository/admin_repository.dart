import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/admin_model.dart';
import 'package:medicare/models/feedback_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/enums/accounts.dart';

final adminRepositoryProvider = Provider(
  (ref) => AdminRepository(firestore: FirebaseFirestore.instance),
);

class AdminRepository {
  AdminRepository({required this.firestore});

  final FirebaseFirestore firestore;
  AdminModel? adminInfo;
  List<UserModel>? approvalRequests;
  List<FeedbackModel>? feedbacksList;

  Stream<List<UserModel>> searchUser(String query) {
    if (query.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName') // Order by user name
          .startAt([query.toUpperCase()])
          .endAt([query.toLowerCase() + '\uf8ff'])
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return UserModel.fromMap(doc.data());
            }).where((user) {
              return user.userName
                  .toLowerCase()
                  .startsWith(query.toLowerCase());
            }).toList();
          });
    } else {
      return Stream.value([]); // Return an empty list if query is empty
    }
  }

  Future<void> getFeedbackFromUIDs() async {
    feedbacksList = [];

    try {
      for (String uid in adminInfo!.feedback) {
        DocumentSnapshot feedbackSnapshot =
            await firestore.collection('feedback').doc(uid).get();

        // Process each feedback document
        Map<String, dynamic> feedbackData =
            feedbackSnapshot.data() as Map<String, dynamic>;
        FeedbackModel feedback = FeedbackModel.fromMap(feedbackData);
        feedbacksList!.add(feedback); // Add feedback to the list
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeUser(String uid) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(UserModel newData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(newData.uid)
          .update(newData.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFeedback(String uid) async {
    try {
      feedbacksList!.removeWhere((feedback) => feedback.uid == uid);
      adminInfo!.feedback.remove(uid);

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('appdata')
          .update({
        'feedbacks': FieldValue.arrayRemove([uid])
      });
      print(feedbacksList);
      print('removed successfully');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptUser(String uid) async {
    try {
      adminInfo!.approvals.remove(uid);

      removeUserModelFromList(approvalRequests, uid);

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('appdata')
          .update(adminInfo!.toJson());

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'isDenied': false,
        'isAdminApproved': true,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectUser(String uid) async {
    try {
      adminInfo!.approvals.remove(uid);
      removeUserModelFromList(approvalRequests, uid);

      await FirebaseFirestore.instance
          .collection('admin')
          .doc('appdata')
          .update(adminInfo!.toJson());

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'isDenied': true});
    } catch (e) {
      rethrow;
    }
  }

  UserModel? removeUserModelFromList(
      List<UserModel>? approvalRequests, String uid) {
    if (approvalRequests == null) return null;

    int index = approvalRequests.indexWhere((user) => user.uid == uid);
    if (index != -1) {
      return approvalRequests.removeAt(index);
    }
    return null;
  }

  Future<void> getUsersInApprovalList() async {
    approvalRequests = [];
    try {
      for (String uid in adminInfo!.approvals) {
        DocumentSnapshot userSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;
          UserModel user = UserModel.fromMap(userData);
          approvalRequests!.add(user);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadInfo() async {
    try {
      DocumentSnapshot adminSnapshot =
          await firestore.collection('admin').doc('appdata').get();

      Map<String, dynamic> data = adminSnapshot.data() as Map<String, dynamic>;

      adminInfo = AdminModel.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }

  Stream<int> getAccountTypeCount(AccountType accountType) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('userAccountType', isEqualTo: accountType.name)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Stream<List<UserModel>> getAllAccountTypeList(AccountType accountType) {
    return firestore
        .collection('users')
        .where('userAccountType', isEqualTo: accountType.name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) {
        return UserModel.fromMap(e.data());
      }).toList();
    });
  }

  getApprovalRequests() {
    return approvalRequests;
  }

  getAdminInfo() {
    return adminInfo;
  }
}

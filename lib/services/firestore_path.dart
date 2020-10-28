class FirestorePath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) => 'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';

  static String profile(String uid, String type) => 'users/$uid/profiles/$type';
  static String profiles(String uid) => 'users/$uid/profiles';

  static String users() => 'users';

  static String groups() => 'groups';
  static String group(String groupId) => 'groups/$groupId';

  static String messages(String groupId) => 'messages/$groupId/messages/';
  static String message(String groupId, String messageID) => 'messages/$groupId/messages/$messageID';

  static String schools() => 'schools';
  static String school(String schoolId) => 'schools/$schoolId';

  static String friend(String uid, String friendID) => 'users/$uid/friends/$friendID';
  static String friends(String uid) => 'users/$uid/friends';

  static String request(String uid, String id) => 'users/$uid/requests/$id';
  static String requests(String uid) => 'users/$uid/requests';
  static String bloked(String uid, String id) => 'users/$uid/blokeds/$id';
  static String blokeds(String uid) => 'users/$uid/blokeds';

  static String parents() => 'parents';
  static String parent(String userId) => 'parents/$userId';
}

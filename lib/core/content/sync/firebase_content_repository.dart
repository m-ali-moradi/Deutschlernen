import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A repository that simplifies access to grammar, vocabulary, and exercises
/// stored in Firebase Firestore.
class FirebaseContentRepository {
  final FirebaseFirestore _firestore;

  FirebaseContentRepository(this._firestore);

  /// Collection paths for versioned content
  static const String grammarPath = 'content/v1/grammar_topics';
  static const String grammarDetailsPath = 'content/v1/grammar_details';
  static const String vocabPath = 'content/v1/vocabulary_words';
  static const String exercisePath = 'content/v1/exercises';
  static const String vocabGroupsPath = 'content/v1/vocabulary_groups';
  static const String vocabCategoriesPath = 'content/v1/vocabulary_categories';

  /// Fetches a list of all grammar topics available on the cloud.
  /// Only fetches metadata (id, title, level, category) to save bandwidth.
  Future<List<Map<String, dynamic>>> getGrammarTopicsMetadata() async {
    final snapshot = await _firestore.collection(grammarPath).get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  /// Fetches a list of all vocabulary words available on the cloud.
  Future<List<Map<String, dynamic>>> getVocabularyWordsMetadata() async {
    final snapshot = await _firestore.collection(vocabPath).get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  /// Fetches a list of all exercises available on the cloud.
  Future<List<Map<String, dynamic>>> getExercisesMetadata() async {
    final snapshot = await _firestore.collection(exercisePath).get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getVocabularyGroupsMetadata() async {
    final snapshot = await _firestore.collection(vocabGroupsPath).get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getVocabularyCategoriesMetadata() async {
    final snapshot = await _firestore.collection(vocabCategoriesPath).get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  Future<List<Map<String, dynamic>>> getVocabularyWordsByCategoryMetadata(
    String categoryId,
  ) async {
    final snapshot = await _firestore
        .collection(vocabPath)
        .where('category', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => {
              'id': doc.id,
              ...doc.data(),
            })
        .toList();
  }

  /// Fetches the full content of a specific grammar topic.
  Future<Map<String, dynamic>?> getGrammarTopic(String id) async {
    final doc = await _firestore.collection(grammarPath).doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Fetches the translated metadata and rich detail JSON payload for a grammar topic.
  /// The document ID in Firestore is expected to be '{topicId}_{languageCode}'.
  Future<Map<String, dynamic>?> getGrammarTopicDetailMap(
      String topicId, String languageCode) async {
    final docId = '${topicId}_$languageCode';
    final doc = await _firestore.collection(grammarDetailsPath).doc(docId).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Fetches the full content of a specific vocabulary word.
  Future<Map<String, dynamic>?> getVocabularyWord(String id) async {
    final doc = await _firestore.collection(vocabPath).doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }

  /// Fetches the full content of a specific exercise.
  Future<Map<String, dynamic>?> getExercise(String id) async {
    final doc = await _firestore.collection(exercisePath).doc(id).get();
    if (!doc.exists) return null;
    return {'id': doc.id, ...doc.data()!};
  }
}

final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseContentRepositoryProvider =
    Provider<FirebaseContentRepository>((ref) {
  return FirebaseContentRepository(ref.watch(firestoreProvider));
});

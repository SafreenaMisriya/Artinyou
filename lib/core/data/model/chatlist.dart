
class ConversationModel {
  final String documentId;
  final DateTime initiatedAt;
  final String initiatedBy;
  final Map<String, dynamic> lastMessage;
  final DateTime lastUpdatedAt;
  final List<String> participants;
  final List<String> participantIds;

  ConversationModel({
     this.documentId= "",
    required this.initiatedAt,
    required this.initiatedBy,
    required this.lastMessage,
    required this.lastUpdatedAt,
    required this.participants,
    required this.participantIds,
  });

  factory ConversationModel.fromFirestore(Map<String, dynamic> data,{String id = ''}) {
    return ConversationModel(
      documentId: id,
      initiatedAt: data['initiatedAt'].toDate(),
      initiatedBy: data['initiatedBy'],
      lastMessage: data['lastMessage'],
      lastUpdatedAt: data['lastUpdatedAt'].toDate(),
      participants: List<String>.from(data['participants']),
      participantIds: List<String>.from(data['participantIds']),
    );
  }
}
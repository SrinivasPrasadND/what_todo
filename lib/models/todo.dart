class Todo{
  final int id;
  final int taskId;
  final String text;
  final int isDone;

  Todo({this.id,this.text,this.isDone, this.taskId});

  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'text': text,
      'isDone': isDone,
      'taskId': taskId
    };
  }
 }
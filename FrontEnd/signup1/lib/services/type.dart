class Coursetype{
  final String ?type_name;

  Coursetype(this.type_name);
  Coursetype.fromJson(Map<String,dynamic>json, this.type_name);
  Map<String,dynamic> toJson()=>{
    "type_name":this.type_name
  };
}

class Topic{
  final String ?topic_name,type_id;

  Topic(this.topic_name,this.type_id);
  Topic.fromJson(Map<String,dynamic>json, this.topic_name,this.type_id);
  Map<String,dynamic> toJson()=>{
    "topic_name":this.topic_name,
    "type_id":this.type_id
  };
}

class Booking{
  final String ?user_id,course_id;

  Booking(this.user_id,this.course_id);
  Booking.fromJson(Map<String,dynamic>json, this.user_id,this.course_id);
  Map<String,dynamic> toJson()=>{
    "user_id":this.user_id,
    "course_id":this.course_id,
  };
}

class Video{
  final String ?video_topic,video_id,video_discription,course_id;

  Video(this.video_topic,this.video_id,this.video_discription,this.course_id);
  Video.fromJson(Map<String,dynamic>json, this.video_topic,this.video_id,this.video_discription,this.course_id);
  Map<String,dynamic> toJson()=>{
    "video_topic":this.video_topic,
    "video_id":this.video_id,
    "video_discription":this.video_discription,
    "course_id":this.course_id
  };
}

class Payment{
  final String ?booking_id;

  Payment(this.booking_id);
  Payment.fromJson(Map<String,dynamic>json, this.booking_id);
  Map<String,dynamic> toJson()=>{
    "booking_id":this.booking_id,
  };
}


class Comments{
  final String ?comment,user_id,video_id;

  Comments(this.comment,this.user_id,this.video_id);
  Comments.fromJson(Map<String,dynamic>json, this.comment,this.user_id,this.video_id);
  Map<String,dynamic> toJson()=>{
    "comment":this.comment,
    "user_id":this.user_id,
    "video_id":this.video_id
  };
}

class Document{
  final String ?document_topic,document_file,course_id;

  Document(this.document_topic,this.document_file,this.course_id);
  Document.fromJson(Map<String,dynamic>json, this.document_topic,this.document_file,this.course_id);
  Map<String,dynamic> toJson()=>{
    "document_topic":this.document_topic,
    "document_file":this.document_file,
    "course_id":this.course_id
  };
}

class Commentreply{
  final String ?reply,user_id,comment_id;

  Commentreply(this.reply,this.user_id,this.comment_id);
  Commentreply.fromJson(Map<String,dynamic>json, this.reply,this.user_id,this.comment_id);
  Map<String,dynamic> toJson()=>{
    "reply":this.reply,
    "user_id":this.user_id,
    "comment_id":this.comment_id
  };
}


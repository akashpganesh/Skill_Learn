class Courses{
  final String ?course_name,topic_id,course_duration,course_price,tutor_id,course_image;

  Courses(this.course_name, this.topic_id, this.course_duration, this.course_price,this.tutor_id,this.course_image);
  Courses.fromJson(Map<String,dynamic>json, this.course_name, this.topic_id, this.course_duration, this.course_price,this.tutor_id,this.course_image);
  Map<String,dynamic> toJson()=>{
    "course_name":this.course_name,
    "topic_id":this.topic_id,
    "course_duration":this.course_duration,
    "course_price":this.course_price,
    "tutor_id":this.tutor_id,
    "course_image":this.course_image
  };
}
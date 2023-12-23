class Users{
  final String ?name,email,phone,password,image,user_type;

  Users(this.name, this.email, this.phone, this.password,this.image,this.user_type);
  Users.fromJson(Map<String,dynamic>json, this.name, this.email, this.phone, this.password,this.image,this.user_type);
  Map<String,dynamic> toJson()=>{
    "name":this.name,
    "email":this.email,
    "phone":this.phone,
    "password":this.password,
    "image":this.image,
    "user_type":this.user_type,

  };
}
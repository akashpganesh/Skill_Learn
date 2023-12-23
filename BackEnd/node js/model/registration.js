var mongoose = require("mongoose")
var userSchema=mongoose.Schema({
    name:{
        type: String,
        required: true,
        minlength: 3,
        maxlength: 50,
    },
    email:{
        type: String,
        trim: true,
        required: true,
        unique: true
    },
    phone:{
        type:Number,
        required:true
    },
    password:{
        type:String,
        required:true
    },
    image:{
        type:String
    },
    user_status:{
        type:Number,
        default: 0
    },
    user_type:{
        type:String,
        required:true
        }
})

module.exports=mongoose.model("User",userSchema)
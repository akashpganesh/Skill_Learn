var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var courseSchema=mongoose.Schema({
    course_name:{
        type: String,
        required: true,
        minlength: 3,
        maxlength: 50,
    },
    topic_id:{
        type: ObjectId,
        required: true,
    },
    course_duration:{
        type:String,
        required:true
    },
    course_price:{
        type:String,
        required:true
    },
    tutor_id:{
        type:ObjectId
    },
    course_image:{
        type:String
    }
})

module.exports=mongoose.model("Course",courseSchema)
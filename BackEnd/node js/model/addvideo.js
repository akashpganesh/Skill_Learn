var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var videoSchema=mongoose.Schema({
    video_topic:{
        type: String,
        required: true,
    },
    video_id:{
        type: String,
        required: true,
    },
    video_discription:{
        type:String,
    },
    course_id:{
        type:ObjectId,
    }
})

module.exports=mongoose.model("Video",videoSchema)
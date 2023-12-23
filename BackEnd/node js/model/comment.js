var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var commentSchema=mongoose.Schema({
    comment:{
        type: String,
        required: true,
    },
    video_id:{
        type:ObjectId,
    },
    user_id:{
        type:ObjectId,
    },
})

module.exports=mongoose.model("Comment",commentSchema)
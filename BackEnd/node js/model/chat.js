var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var chatSchema=mongoose.Schema({
    message:{
        type: String,
        required: true,
    },
    course_id:{
        type:ObjectId,
    },
    user_id:{
        type:ObjectId,
    },
})

module.exports=mongoose.model("Chat",chatSchema)
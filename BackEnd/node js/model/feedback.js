var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var feedbackSchema=mongoose.Schema({
    feedback_subject:{
        type: String,
        required: true,
    },
    feedback_discription:{
        type: String,
        required: true,
    },
    user_id:{
        type:ObjectId,
    },
})

module.exports=mongoose.model("Feedback",feedbackSchema)
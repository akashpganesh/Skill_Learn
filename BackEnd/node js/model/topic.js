var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var topicSchema=mongoose.Schema({
    topic_name:{
        type: String,
        required: true,
    },
    type_id:{
        type: ObjectId,
        required: true,
    }
})
module.exports=mongoose.model("Topic",topicSchema)
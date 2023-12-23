var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var documentSchema=mongoose.Schema({
    document_topic:{
        type: String,
        required: true,
    },
    document_file:{
        type: String,
        required: true,
    },
    course_id:{
        type: ObjectId
    }
})

module.exports=mongoose.model("Document",documentSchema)
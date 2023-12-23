var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var commentreplySchema=mongoose.Schema({
    reply:{
        type: String,
        required: true,
    },
    user_id:{
        type:ObjectId,
        required: true
    },
    comment_id:{
        type:ObjectId,
        required:true
    }
})

module.exports=mongoose.model("Commentreply",commentreplySchema)
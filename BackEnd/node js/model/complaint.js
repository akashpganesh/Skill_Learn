var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var complaintSchema=mongoose.Schema({
    complaint:{
        type: String,
        required: true,
    },
    reply:{
        type:String,
        default:""
    },
    type_id:{
        type:ObjectId
    },
    user_id:{
        type:ObjectId
    }
})
module.exports=mongoose.model("Complaint",complaintSchema)
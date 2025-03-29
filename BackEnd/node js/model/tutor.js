var mongoose = require("mongoose")
const {ObjectId} = mongoose.Schema
var tutorSchema=mongoose.Schema({
    id:{
        type: ObjectId
    },
    qualification:{
        type: String,
        default:""
    },
    proof:{
        type:String,
        default:""
    },
    age:{
        type: Number,
        default:""
    }
})

module.exports=mongoose.model("Tutor",tutorSchema)
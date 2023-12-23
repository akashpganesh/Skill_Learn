var mongoose = require("mongoose")
const {ObjectId} = mongoose.Schema
var tutorSchema=mongoose.Schema({
    id:{
        type: ObjectId
    },
    qualification:{
        type: String,
        minlength: 3,
        maxlength: 50,
    },
    age:{
        type: Number,
    }
})

module.exports=mongoose.model("Tutor",tutorSchema)
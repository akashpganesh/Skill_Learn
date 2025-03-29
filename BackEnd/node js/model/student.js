var mongoose = require("mongoose")
const { ObjectId } = mongoose.Schema
var studentSchema=mongoose.Schema({
    id: {
        type: ObjectId
    },
    age:{
        type: Number,
        default:""
    }
})

module.exports=mongoose.model("Student",studentSchema)
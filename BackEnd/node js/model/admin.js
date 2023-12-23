var mongoose = require("mongoose")
const { ObjectId } = mongoose.Schema
var adminSchema=mongoose.Schema({
    id: {
        type: ObjectId
    },
    age:{
        type: Number,
    }
})

module.exports=mongoose.model("Admin",adminSchema)
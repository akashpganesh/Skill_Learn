var mongoose = require("mongoose")
var coursetypeSchema=mongoose.Schema({
    type_name:{
        type: String,
        required: true,
    }
})
module.exports=mongoose.model("Coursetype",coursetypeSchema)
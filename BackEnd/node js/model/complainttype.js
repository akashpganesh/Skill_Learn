var mongoose = require("mongoose")
var complainttypeSchema=mongoose.Schema({
    type:{
        type: String,
        required: true,
    },
})
module.exports=mongoose.model("Complainttype",complainttypeSchema)
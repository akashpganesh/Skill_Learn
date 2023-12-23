var mongoose = require("mongoose")
const { ObjectId } = mongoose.Schema
var userupSchema=mongoose.Schema({
    id: {
        type: ObjectId
    },
    age:{
        type: Number,
    }
})

module.exports=mongoose.model("Userup",userupSchema)
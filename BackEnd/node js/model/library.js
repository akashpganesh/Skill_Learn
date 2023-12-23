var mongoose = require("mongoose")
var librarySchema=mongoose.Schema({
    book_name:{
        type: String,
        required: true,
        minlength: 3,
        maxlength: 50,
    },
    book_author:{
        type: String,
        required: true,
    },
    book_file:{
        type: String,
        required: true,
    },
    book_price:{
        type:String,
        required:true
    }
})
module.exports=mongoose.model("Library",librarySchema)
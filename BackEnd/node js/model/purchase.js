var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var bookingSchema=mongoose.Schema({
    course_id:{
        type: ObjectId,
        required: true,
    },
    user_id:{
        type: ObjectId,
        required: true,
    },
    booking_date:{
        type: Date,
    }
})

module.exports=mongoose.model("Booking",bookingSchema)
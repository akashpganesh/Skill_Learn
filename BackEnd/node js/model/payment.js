var mongoose = require("mongoose")
const {ObjectId}=require('mongodb')
var paymentSchema=mongoose.Schema({
    booking_id:{
        type: ObjectId,
        required: true,
    },
    payment_date:{
        type: Date
    }
})

module.exports=mongoose.model("Payment",paymentSchema)
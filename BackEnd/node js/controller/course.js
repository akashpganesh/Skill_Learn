var Course=require('../model/course')
var Coursetype=require('../model/CourseType')
var Topic=require('../model/topic')
var Booking=require('../model/purchase')
var Payment=require('../model/payment')
const {ObjectId}=require('mongodb');

exports.addCourse=(req,res)=>{
    console.log(req.body)
    Course.findOne({course_name:req.body.course_name,topic_id:req.body.topic_id},(err,course)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(course){
            return res.status(404).json({error:"The course already exists"})
        }
        else{
            let course=new Course(req.body)
            course.save((err,newCourse)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newCourse)
                }
            })
        }
    })
}

exports.addCoursetype=(req,res)=>{
    console.log(req.body)
    Coursetype.findOne({type_name:req.body.type_name},(err,coursetype)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(coursetype){
            return res.status(404).json({error:"The course type already exists"})
        }
        else{
            let coursetype=new Coursetype(req.body)
            coursetype.save((err,newCoursetype)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newCoursetype)
                }
            })
        }
    })
}

exports.dispType=(req,res)=>{
    console.log(req.body)
    Coursetype.find({},(err,coursetype)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(coursetype){

            return res.status(201).json(coursetype)
        }
        else{
            return res.status(404).json({error})
        }
    })
}

exports.addTopic=(req,res)=>{
    console.log(req.body)
    Topic.findOne({topic_name:req.body.topic_name,type_id:req.body.type_id},(err,topic)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(topic){
            return res.status(404).json({error:"The topic already exists"})
        }
        else{
            let topic=new Topic(req.body)
            topic.save((err,newTopic)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newTopic)
                }
            })
        }
    })
}

exports.dispTopic=(req,res)=>{
    console.log(req.body)
    Topic.find({type_id:req.body.type_id},(err,topic)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(topic){

            return res.status(201).json(topic)
        }
        else{
            return res.status(404).json({error})
        }
    })
}

exports.findCourse=(req,res)=>{
    console.log(req.body)
    Course.find({course_specialization:req.body.course_specialization},(err,course)=>{
        if(err){
            return res.status(404).json({error:"Error1"})
        }
        else if(course){

            return res.status(201).json(course)
        }
        else{
            return res.status(404).json({error})
        }
    })
}

exports.dispCourse=(req,res)=>{
    console.log(req.body)
    var tutorid=req.body.tutor_id
    Course.aggregate([
        {
            $lookup: {
              from: 'topics',
              localField: 'topic_id',
              foreignField: '_id',
              as: 'topics'
            }
          },
          {
            $unwind: {
              path: '$topics',
              preserveNullAndEmptyArrays: true
            }
          },
          {
            $lookup: {
              from: 'coursetypes',
              localField: 'topics.type_id',
              foreignField: '_id',
              as: 'type'
            }
          },
          {
            $match: {
                 "tutor_id":new ObjectId(tutorid)
             }

        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}

exports.selectCourse=(req,res)=>{
    console.log(req.body)
    var id=req.body._id
    Course.aggregate([
        {
            $lookup: {
              from: 'topics',
              localField: 'topic_id',
              foreignField: '_id',
              as: 'topics'
            }
          },
          {
            $lookup: {
              from: 'coursetypes',
              localField: 'topics.type_id',
              foreignField: '_id',
              as: 'type'
            }
          },
          {
            $match: {
                 "_id":new ObjectId(id)
             }

        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}

exports.searchCourse=(req,res)=>{
    console.log(req.body)
    Course.find({},(err,course)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(course){

            return res.status(201).json(course)
        }
        else{
            return res.status(404).json({err})
        }
    })
}

exports.bookingCourse=(req,res)=>{
    console.log(req.body)
    Booking.findOne({course_id:req.body.course_id,user_id:req.body.user_id},(err,booking)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(booking){
            return res.status(404).json({error:"The course already purchased"})
        }
        else{
            let booking=new Booking(req.body)
            booking.save((err,newBooking)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newBooking)
                }
            })
        }
    })
}

exports.getCourse=(req,res)=>{
    console.log(req.body)
    var userid=req.body.user_id
    Payment.aggregate([
        {
            $lookup: {
              from: "bookings",
              localField: "booking_id",
               foreignField: "_id",
               as: "bookings"
            },
        },
         {
             $lookup: {
              from: "courses",
               localField: "bookings.course_id",
                foreignField: "_id",
                as: "courses"
             },
         },
         {
            $lookup: {
             from: "topics",
              localField: "courses.topic_id",
               foreignField: "_id",
               as: "topics"
            },
        },
        {
            $lookup: {
             from: "coursetypes",
              localField: "topics.type_id",
               foreignField: "_id",
               as: "type"
            },
        },
        {
            $match: {
                 "bookings.user_id":new ObjectId(userid)
             }

        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}


exports.addPayment=(req,res)=>{
    console.log(req.body)
    Payment.findOne({booking_id:ObjectId(req.body.booking_id)},(err,payment)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(payment){
            return res.status(404).json({error:"already paid"})
        }
        else{
            let payment=new Payment(req.body)
            payment.save((err,newPayment)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newPayment)
                }
            })
        }
    })
}


exports.getBookings=(req,res)=>{
    console.log(req.body)
    var userid=req.body.user_id
    Booking.aggregate([
         {
             $lookup: {
              from: "courses",
               localField: "course_id",
                foreignField: "_id",
                as: "courses"
             },
         },
         {
            $lookup: {
             from: "topics",
              localField: "courses.topic_id",
               foreignField: "_id",
               as: "topics"
            },
        },
        {
            $lookup: {
             from: "coursetypes",
              localField: "topics.type_id",
               foreignField: "_id",
               as: "type"
            },
        },
        {
            $match: {
                 "user_id":new ObjectId(userid)
             }

        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}

exports.Search=(req,res)=>{
    console.log(req.body)
    var topicid=req.body.topic_id
    Course.aggregate([
         {
            $lookup: {
              from: "topics",
              localField: "topic_id",
               foreignField: "_id",
               as: "topics"
            },
        },
        {
            $lookup: {
             from: "coursetypes",
              localField: "topics.type_id",
               foreignField: "_id",
               as: "type"
            },
        },
        {
            $match: {
                 "topic_id":new ObjectId(topicid)
             }

        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}


exports.CourseList=(req,res)=>{
    console.log(req.body)
    Course.aggregate([
         {
            $lookup: {
              from: "topics",
              localField: "topic_id",
               foreignField: "_id",
               as: "topics"
            },
        },
        {
            $lookup: {
             from: "coursetypes",
              localField: "topics.type_id",
               foreignField: "_id",
               as: "type"
            },
        }
    ]).exec(
        function(err,data){
            if(err){
                return res.status(401).json(err);}
            if(data){
                return res.status(201).json(data);
            }
        }
    )
}
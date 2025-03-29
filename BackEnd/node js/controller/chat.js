var Chat=require('../model/chat')
const {ObjectId}=require('mongodb');
exports.sendMessage=(req,res)=>{
    console.log(req.body)
    let chat=new Chat(req.body)
    chat.save((err,newChat)=>{
        if(err){
            return res.status(404).json({error:"Error in inserting data"})
        }
        else{
            return res.status(201).json(newChat)
        }
    })
}

exports.dispChat=(req,res)=>{
    console.log(req.body)
    var courseid=req.body.course_id
    Chat.aggregate([
        {
            $lookup: {
              from: "users",
              localField: "user_id",
               foreignField: "_id",
               as: "user"
            },
        },
        {
            $match: {
                 "course_id":new ObjectId(courseid)
             }
        },
        {
            $project: {
              _id: 1,
              message: 1,
              user_id: 1,
              user: {
                _id: 1,
                name: 1,
              },
            },
          },
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
       
var Complainttype=require('../model/complainttype')
var Complaint=require('../model/complaint')
const {ObjectId}=require('mongodb');

exports.addComplainttype=(req,res)=>{
    console.log(req.body)
    Complainttype.findOne({type:req.body.type},(err,complainttype)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(complainttype){
            return res.status(404).json({error:"already exists"})
        }
        else{
            let complainttype=new Complainttype(req.body)
            complainttype.save((err,newComplainttype)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newComplainttype)
                }
            })
        }
    })
}

exports.addComplaint=(req,res)=>{
    console.log(req.body)
    let complaint=new Complaint(req.body)
    complaint.save((err,newComplaint)=>{
        if(err){
            return res.status(404).json({error:"Error in inserting data"})
        }
        else{
            return res.status(201).json(newComplaint)
        }
    })
}

exports.dispComplaintType=(req,res)=>{
    console.log(req.body)
    Complainttype.find({},(err,complainttype)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(complainttype){

            return res.status(201).json(complainttype)
        }
        else{
            return res.status(404).json({err})
        }
    })
}

exports.ComplaintList=(req,res)=>{
    console.log(req.body)
    Complaint.aggregate([
         {
            $lookup: {
              from: "complainttypes",
              localField: "type_id",
               foreignField: "_id",
               as: "type"
            },
        },
        {
            $lookup: {
             from: "users",
              localField: "user_id",
               foreignField: "_id",
               as: "user"
            },
        },
        {
            $project: {
              _id: 1,
              complaint: 1,
              type_id: 1,
              user_id: 1,
              reply: 1,
              type: {
                _id: 1,
                type: 1
              },
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

exports.addComplaintReply = (req, res) => {
    console.log(req.body)
    Complaint.findOne({ _id: req.body._id }, (err, complaint) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (complaint) {
            Complaint.updateOne( 
                { _id: new ObjectId(complaint._id)},
                {
                  $set:
                    {
                       reply:req.body.reply,
                    }
                },(err,u)=>{
                    if(err){
                        return res.status(400).json({ 'msg': "Error occured"});
                    }
                    if(u){
                        return res.status(201).json({ 'msg': "Status Updated"});
                    }
                } 
            )
        }
    });
};

exports.dispComplaintReply=(req,res)=>{
    console.log(req.body)
    var userid=req.body.user_id
    Complaint.aggregate([
         {
            $lookup: {
              from: "complainttypes",
              localField: "type_id",
               foreignField: "_id",
               as: "type"
            },
        },
        {
            $lookup: {
             from: "users",
              localField: "user_id",
               foreignField: "_id",
               as: "user"
            },
        },
        {
            $project: {
              _id: 1,
              complaint: 1,
              type_id: 1,
              user_id: 1,
              reply: 1,
              type: {
                _id: 1,
                type: 1
              },
              user: {
                _id: 1,
                name: 1,
              },
            },
          },
          {
            $match: {
              user_id: new ObjectId(userid)
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

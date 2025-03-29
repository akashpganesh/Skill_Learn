var Student = require('../model/student');
const {ObjectId}=require('mongodb');
exports.addStudent = (req, res) => {
    console.log(req.body)
    Student.findOne({ id: req.body.id }, (err, student) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (student) {
            Student.updateOne( 
                { _id: new ObjectId(student._id) }, 
                {
                  $set: 
                    {
                        age:req.body.age
                    }
                },(err,u)=>{
                    if(err){
                        return res.status(400).json({ 'msg': "Error occured"});
                    }
                    if(u){
                        return res.status(201).json({ 'msg': "Profile Updated"});
                    }
                } 
            )
        }
    });
};

exports.deleteStudent=(req,res)=>{
    console.log(req.body)
    Student.deleteOne({id:req.body.id}, (err, student)=>{
        if(err){
            return res.status(404).json({error:"error"})
        }
        else if(student){
            return res.status(201).json(student)
        }
        else{
            return res.status(404).json({error:t})
        }
    })
}

exports.dispStudent=(req,res)=>{
    console.log(req.body)
    var id=req.body.id
    Student.aggregate([
         {
            $lookup: {
              from: "users",
              localField: "id",
               foreignField: "_id",
               as: "user"
            },
        },
        {
            $match: {
                 "id":new ObjectId(id)
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
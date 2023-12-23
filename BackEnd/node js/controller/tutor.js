var Tutor = require('../model/tutor');
const {ObjectId}=require('mongodb');
exports.addTutor = (req, res) => {
    console.log(req.body)

    Tutor.findOne({ id: req.body.id }, (err, tutor) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (tutor) {
            Tutor.updateOne( 
                { _id: ObjectId(tutor._id) }, 
                {
                  $set: 
                    {
                        qualification:req.body.qualification,
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
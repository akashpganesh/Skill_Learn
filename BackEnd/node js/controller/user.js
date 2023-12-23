var Userup = require('../model/user');
const {ObjectId}=require('mongodb');
exports.userUp = (req, res) => {
    console.log(req.body)

    Userup.findOne({ id: req.body.id }, (err, userup) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (userup) {
            Userup.updateOne( 
                { _id: ObjectId(userup._id) }, 
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
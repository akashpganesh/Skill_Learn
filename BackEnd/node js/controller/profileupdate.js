var User = require('../model/registration');
const {ObjectId}=require('mongodb');


exports.updateProfile = (req, res) => {
    console.log(req.body)
    User.findOne({ _id: req.body._id }, (err, user) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (user) {
            User.updateOne( 
                { _id: new ObjectId(user._id) }, 
                {
                  $set: 
                    {
                        name:req.body.name,
                        email:req.body.email,
                        phone:req.body.phone,
                        image:req.body.image
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


exports.updatePassword = (req, res) => {
    console.log(req.body)

    User.findOne({ _id: req.body._id}, (err, user) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (user) {
            User.updateOne( 
                { _id: ObjectId(user._id) },
                {
                  $set: 
                    {
                        password:req.body.password
                    }
                },(err,u)=>{
                    if(err){
                        return res.status(400).json({ 'msg': "Error occured"});
                    }
                    if(u){
                        return res.status(201).json({ 'msg': "Password Updated"});
                    }
                } 
            )
        }
    });
};


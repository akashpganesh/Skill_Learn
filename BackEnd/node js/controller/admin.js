var Admin = require('../model/admin');
const {ObjectId}=require('mongodb');
exports.addAdmin = (req, res) => {
    console.log(req.body)

    Admin.findOne({ id: req.body.id }, (err, admin) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err });
        }
        if (admin) {
            Admin.updateOne( 
                { _id: ObjectId(admin._id) }, 
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
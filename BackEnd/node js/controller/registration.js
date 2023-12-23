var User = require('../model/registration')
var Tutor = require('../model/tutor')
var Admin = require('../model/admin')

var jwt = require("jsonwebtoken")
const expressJwt = require('express-jwt')

const {ObjectId}=require('mongodb');
exports.addUser = (req, res) => {
    console.log(req.body)
    User.findOne({ email: req.body.email }, (err, user) => {
        if (err) {
            // console.log("err")
            return res.status(400).json({ 'msg': err })
        }
        if (user) {
            return res.status(400).json({ 'msg': 'The user already exists' })
        }
        let newUser = User(req.body);
        newUser.save((err, user) => {
            if (err) {
                //console.log("err")
                return res.status(400).json({ 'msg': err })
            }
            if(req.body.user_type == "Tutor"){
                req.body.id = ObjectId(user._id)
                let newTutor = Tutor(req.body)
                newTutor.save((err,tutor) => {
                    if (err) {
                        return res.status(400).json({ 'msg': "Error occured" })
                    }
                })
            }
            if(req.body.user_type == "Admin"){
                req.body.id = ObjectId(user._id)
                let newAdmin = Admin(req.body)
                newAdmin.save((err,admin) => {
                    if (err) {
                        return res.status(400).json({ 'msg': "Error occured" })
                    }
                })
            }
            if(req.body.user_type == "User"){
                req.body.id = ObjectId(user._id)
                let newUserup = Userup(req.body)
                newUserup.save((err,userup) => {
                    if (err) {
                        return res.status(400).json({ 'msg': "Error occured" })
                    }
                })
            }
            return res.status(201).json(user)
        })

    })
}





exports.login=(req,res)=>{
    console.log(req.body)
    User.findOne({email:req.body.email,password:req.body.password},(err,user)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(user){

            const token = jwt.sign({_id: user._id}, process.env.SECRET)

            res.cookie("token",token, {expire: new Date() + 9999})

            return res.status(201).json({token,user})
        }
        else{
            return res.status(404).json({error:t})
        }
    })
}

exports.findUser=(req,res)=>{
    console.log(req.body)
    User.findOne({_id:req.body._id},(err,user)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(user){

            return res.status(201).json(user)
        }
        else{
            return res.status(404).json({error:t})
        }
    })
}

exports.dispUsers=(req,res)=>{
    console.log(req.body)
    User.find({user_type:req.body.user_type},(err,user)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(user){

            return res.status(201).json(user)
        }
        else{
            return res.status(404).json({error:t})
        }
    })
}


exports.deleteUsers=(req,res)=>{
    console.log(req.body)
    User.deleteOne({_id:req.body._id}, (err, user)=>{
        if(err){
            return res.status(404).json({error:"error"})
        }
        else if(user){
            return res.status(201).json(user)
        }
        else{
            return res.status(404).json({error:t})
        }
    })
}

exports.acceptUser = (req, res) => {
    console.log(req.body)
    User.findOne({ _id: req.body._id }, (err, user) => {
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
                        user_status:req.body.user_status,
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







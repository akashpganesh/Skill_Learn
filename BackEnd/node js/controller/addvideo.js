var Video=require('../model/addvideo')
var Comment=require('../model/comment')
var Commentreply=require('../model/CommentReply')
const {ObjectId}=require('mongodb');

exports.addVideo=(req,res)=>{
    console.log(req.body)
    
            let video=new Video(req.body)
            video.save((err,newVideo)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newVideo)
                }
            })
        }

    exports.dispVideo=(req,res)=>{
            console.log(req.body)
            Video.find({course_id:req.body.course_id},(err,video)=>{
                if(err){
                    return res.status(404).json({error:"Error"})
                }
                else if(video){
        
                    return res.status(201).json(video)
                }
                else{
                    return res.status(404).json({error})
                }
            })
    }

    exports.selVideo=(req,res)=>{
        console.log(req.body)
        Video.findOne({_id:req.body._id},(err,video)=>{
            if(err){
                return res.status(404).json({error:"Error"})
            }
            else if(video){
    
                return res.status(201).json(video)
            }
            else{
                return res.status(404).json({error})
            }
        })
}

exports.addComment=(req,res)=>{
    console.log(req.body)
            let comment=new Comment(req.body)
            comment.save((err,newComment)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newComment)
                }
            })
        }

        exports.commentReply = (req, res) => {
            console.log(req.body)
            let commentreply=new Commentreply(req.body)
            commentreply.save((err,newCommentreply)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newCommentreply)
                }
            })
        }

        exports.dispComment=(req,res)=>{
            console.log(req.body)
            var videoid=req.body.video_id
            Comment.aggregate([
                 {
                    $lookup: {
                      from: "commentreplies",
                      localField: "_id",
                       foreignField: "comment_id",
                       as: "replys"
                    },
                },
                {
                    $match: {
                         "video_id":new ObjectId(videoid)
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
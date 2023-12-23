var Document=require('../model/addDocument')
exports.addDocument=(req,res)=>{
    console.log(req.body)
            let document=new Document(req.body)
            document.save((err,newDocument)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newDocument)
                }
            })
        }

        exports.dispDocuments=(req,res)=>{
            console.log(req.body)
            Document.find({course_id:req.body.course_id},(err,document)=>{
                if(err){
                    return res.status(404).json({error:"Error"})
                }
                else if(document){
        
                    return res.status(201).json(document)
                }
                else{
                    return res.status(404).json({error})
                }
            })
    }
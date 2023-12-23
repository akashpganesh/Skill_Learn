var Library=require('../model/library')
exports.addLibrary=(req,res)=>{
    console.log(req.body)
    Library.findOne({book_name:req.body.book_name,book_author:req.body.book_author},(err,library)=>{
        if(err){
            return res.status(404).json({error:"Error"})
        }
        else if(library){
            return res.status(404).json({error:"The book already exists"})
        }
        else{
            let library=new Library(req.body)
            library.save((err,newLibrary)=>{
                if(err){
                    return res.status(404).json({error:"Error in inserting data"})
                }
                else{
                    return res.status(201).json(newLibrary)
                }
            })
        }
    })
}
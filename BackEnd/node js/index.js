require("dotenv").config()
const mongoose = require("mongoose")
const bodyParser = require("body-parser")
const cookieParser = require("cookie-parser")
const cors = require("cors")

const express = require('express')
const app = express()
const port = 3000
var userroutes = require('./routes/user') 

mongoose.set('strictQuery', true)
mongoose.connect(process.env.DATABASE,{
    useNewUrlParser: true, 
 useUnifiedTopology: true
})
.then(()=>{
    console.log("DB Connected")
})

app.use(bodyParser.json({limit: '50mb'}));
app.use(bodyParser.json())
app.use(cookieParser())
app.use(cors())

app.use('/api', userroutes)

app.get('/', (req, res) => {
  res.send('Hello World!')
})
app.post('/', (req, res) => {
    res.send('Got a POST request')
    })
    app.put('/user', (req, res) => {
        res.send('Got a PUT request at /user')
        })
        app.delete('/user', (req, res) => {
        res.send('Got a DELETE request at /user')
        })

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
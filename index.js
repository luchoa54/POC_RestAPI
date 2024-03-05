require('dotenv').config()
const express = require('express')
const { MongoClient, ObjectID } = require('mongodb')

const dbURL = process.env.DATABASE_URL
const dbName = process.env.DATABASE_NAME

async function main() {

    const client = new MongoClient(dbURL)

    console.log("Conectando ao banco de dados...")
    await client.connect()
    console.log("Banco de dados conectado com sucesso!")

    const app = express()
    app.use(express.json())

    const db = client.db(dbName)
    const collection = db.collection('posts')

    app.get('/', function (req, res) {
        res.send(dbName)
    })

    app.get('/item', async function (req, res) {
        const items = await collection.find().toArray()

        res.send(items)
    })

    app.get('/item/:id', async function (req, res) {
        const id = req.params.id

        const item = await collection.findOne({
            _id: new ObjectId(id)
        })

        res.send(item)
    })

    app.post('/item', async function (req, res) {
        try {
            const nome = req.body.nome

            const result = await collection.insertOne({ nome })

            res.send("Item adicionado com sucesso!")
        } catch (error) {
            console.log("Erro")
            res.send("Ocorreu uma falha ao adicionar o item!")
        }
    })

    app.put('/item/:id', async function (req, res) {
        const id = req.params.id

        const novoItem = req.body

        collection.updateOne(
            { _id: new ObjectId(id) },
            { $set: novoItem }
        )

        res.send("Item atualizado com sucesso!")
    })

    app.delete('/item/:id', async function (req, res) {
        const id = req.params.id

        await collection.deleteOne({ _id: new ObjectId(id) })

        res.send("Item deletado com sucesso!")
    })

    app.listen(3000)
}

main()
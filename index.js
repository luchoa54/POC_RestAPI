require('dotenv').config()
const express = require('express')
const { MongoClient, ObjectID } = require('mongodb')

class CRUDModel {
    constructor(collection) {
        this.collection = collection
    }

    async getAllItems() {
        return await this.collection.find().toArray()
    }

    async getItemById(id) {
        return await this.collection.findOne({ _id: new ObjectID(id) })
    }

    async addItem(item) {
        try {
            const result = await this.collection.insertOne(item)
            return "Item adicionado com sucesso!"
        } catch (error) {
            console.log("Erro:", error)
            return "Ocorreu uma falha ao adicionar o item!"
        }
    }

    async updateItemById(id, newItem) {
        await this.collection.updateOne({ _id: new ObjectID(id) }, { $set: newItem })
        return "Item atualizado com sucesso!"
    }

    async deleteItemById(id) {
        await this.collection.deleteOne({ _id: new ObjectID(id) })
        return "Item deletado com sucesso!"
    }
}

async function main() {
    const client = new MongoClient(process.env.DATABASE_URL)

    console.log("Conectando ao banco de dados...")
    await client.connect()
    console.log("Banco de dados conectado com sucesso!")

    const app = express()
    app.use(express.json())

    const db = client.db(process.env.DATABASE_NAME)
    const collection = db.collection('posts')
    const crudModel = new CRUDModel(collection)

    app.use((req, res, next) => {
        res.setHeader('Content-Type', 'application/json');
        next();
    });

    app.get('/', function (req, res) {
        res.send("Olá mundo!")
    })

    app.get('/item', async function (req, res) {
        const items = await crudModel.getAllItems()
        res.send(items)
    })

    app.get('/item/:id', async function (req, res) {
        const id = req.params.id
        const item = await crudModel.getItemById(id)
        res.send(item)
    })

    app.post('/item', async function (req, res) {
        const item = req.body
        const resultMessage = await crudModel.addItem(item)
        res.send(resultMessage)
    })

    app.put('/item/:id', async function (req, res) {
        const id = req.params.id
        const newItem = req.body
        const resultMessage = await crudModel.updateItemById(id, newItem)
        res.send(resultMessage)
    })

    app.delete('/item/:id', async function (req, res) {
        const id = req.params.id
        const resultMessage = await crudModel.deleteItemById(id)
        res.send(resultMessage)
    })

    app.listen(3000)
}

main()

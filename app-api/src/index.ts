import 'reflect-metadata'
import 'dotenv/config'
import { EnableServer, HttpServer } from '@thoaiky1992/http-server'
import cors from 'cors'
import helmet from 'helmet'

@EnableServer()
class App extends HttpServer {
  constructor(port: number) {
    super(port)
  }
}
const PORT = Number(process.env.PORT || 3000)
const app = new App(PORT)
// app.setPrefixApi('/api/v1') // If not set, the default will be '/api'
app.applyMiddlewares([cors(), helmet()])
app.start()

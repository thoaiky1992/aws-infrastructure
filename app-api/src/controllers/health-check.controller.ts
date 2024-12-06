import { Controller, GET, Injectable } from '@thoaiky1992/http-server'
import axios from 'axios'
import os from 'os'

@Injectable()
@Controller('health-check')
export default class HeathCheckController {
  @GET()
  async healthCheck() {
    const response = await axios.get('http://169.254.169.254/latest/meta-data/local-ipv4')
    const ip4 = response.data
    return {
      ip4,
      hostname: os.hostname(),
      platform: os.platform(),
      totalMemrory: `${(os.totalmem() / 1024 ** 3).toFixed(2)}G`,
      core: os.cpus()?.length || 0
    }
  }
}

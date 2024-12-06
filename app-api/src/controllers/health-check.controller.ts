import { Injectable } from '@thoaiky1992/http-server/dist/container'
import { Controller, GET } from '@thoaiky1992/http-server/dist/http-server'
import os from 'os'

@Injectable()
@Controller('health-check')
export default class HeathCheckController {
  @GET()
  heathCheck() {
    return {
      hostname: os.hostname(),
      platform: os.platform(),
      totalMemrory: `${(os.totalmem() / 1024 ** 3).toFixed(2)}G`,
      core: os.cpus()?.length || 0
    }
  }
}

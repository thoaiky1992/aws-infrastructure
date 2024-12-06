import { PrismaClient } from '@prisma/client'
import { Logger } from '@thoaiky1992/http-server'
export * from './types'

export class PrismaClientInstance {
  static _instance: PrismaClientInstance
  prisma: PrismaClient

  constructor() {
    this.prisma = new PrismaClient({
      log: [
        {
          emit: 'event',
          level: 'query'
        }
      ]
    })
    const prisma = this.prisma as any
    prisma.$on('query', async (e: any) => {
      let query = e.query
      const params: any = JSON.parse(e.params)
      // Replace $X variables with params in query so it's possible to copy/paste and optimize
      for (let i = 0; i < params.length; i++) {
        // Negative lookahead for no more numbers, ie. replace $1 in '$1' but not '$11'
        const re = new RegExp('\\$' + ((i as number) + 1) + '(?!\\d)', 'g')
        // If string, will quote - if bool or numeric, will not - does the job here
        if (typeof params[i] === 'string') params[i] = "'" + params[i].replace("'", "\\'") + "'"
        //params[i] = JSON.stringify(params[i])
        query = query.replace(re, params[i])
      }
      Logger.log('Prisma Query', `${query} (${e.duration} ms)`)
    })
  }

  static get instance() {
    if (!this._instance) {
      this._instance = new this()
    }
    return this._instance
  }
}

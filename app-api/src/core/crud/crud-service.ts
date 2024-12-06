import { HttpException } from '@thoaiky1992/http-server'
import { PrismaClientInstance } from '../prima-client'
import { StatusCodes } from 'http-status-codes'

export interface ICommonService {
  name: string
}

export type ConditionType = {
  select?: any
  include?: any
  where?: any
  orderBy?: any
  cursor?: any
  take?: any
  skip?: any
  distinct?: any
}

abstract class AbstractCrudService<Data> {
  abstract getMany(conditions: ConditionType): Promise<Data[]>
  abstract getOne(id: number, conditions: ConditionType): Promise<Data>
  abstract createOne(dto: Omit<Data, 'id'>): Promise<Data>
  abstract createMany(dto: Omit<Data, 'id'>[]): Promise<{ count: number }>
  abstract updateOne(id: number, data: Partial<Data>): Promise<Data>
  abstract updateMany(conditions: ConditionType): Promise<{ count: number }>
  abstract deleteOne(id: number): Promise<Data>
  abstract deleteMany(conditions: ConditionType): Promise<{ count: number }>
}

export class CrudService<Model, Data> extends AbstractCrudService<Data> {
  model!: Model
  constructor(modelName: string) {
    super()
    this.model = (PrismaClientInstance.instance.prisma as any)[modelName] as Model
  }
  async getMany(conditions: ConditionType = {}): Promise<Data[]> {
    const data = await (this.model as any).findMany(conditions)
    return data
  }
  async getOne(id: number): Promise<Data> {
    const record = await (this.model as any).findFirst({ where: { id } })
    if (!record) throw new HttpException(StatusCodes.NOT_FOUND, `The record haven't existed with id = ${id}`)
    return record
  }
  async createOne(dto: Omit<Data, 'id'>): Promise<Data> {
    const newRecord = await (this.model as any).create({ data: dto })
    return newRecord
  }
  async createMany(data: Omit<Data, 'id'>[]): Promise<{ count: number }> {
    const newRecords = await (this.model as any).createMany({ data })
    return newRecords
  }
  async updateOne(id: number, data: Partial<Data>): Promise<Data> {
    const record = await (this.model as any).findFirst({ where: { id } })
    if (!record) throw new HttpException(StatusCodes.NOT_FOUND, `The record haven't existed with id = ${id}`)
    const updatedRecord = await (this.model as any).update({ where: { id }, data })
    return updatedRecord
  }
  async updateMany(conditions: ConditionType): Promise<{ count: number }> {
    return await (this.model as any).updateMany(conditions)
  }
  async deleteOne(id: number): Promise<Data> {
    const record = await (this.model as any).findFirst({ where: { id } })
    if (!record) throw new HttpException(StatusCodes.NOT_FOUND, `The record haven't existed with id = ${id}`)
    const deletedRecord = await (this.model as any).delete({ where: { id } })
    return deletedRecord
  }
  async deleteMany(conditions: ConditionType): Promise<{ count: number }> {
    return await (this.model as any).deleteMany(conditions)
  }
}

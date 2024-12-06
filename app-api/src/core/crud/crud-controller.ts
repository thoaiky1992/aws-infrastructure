import { Body, DELETE, GET, Logger, LoggerProperty, Params, POST, PUT, Query } from '@thoaiky1992/http-server'

export class CrudController<T, D> {
  @LoggerProperty()
  logger!: Logger

  protected service!: T
  constructor(service: T) {
    this.service = service
  }
  @GET()
  async getMany(@Query() query: any): Promise<D[]> {
    const records = await (this.service as unknown as any).getMany(query)
    return records
  }
  @GET(':id')
  async getOne(@Params() params: any): Promise<D> {
    const record = await (this.service as unknown as any).getOne(+params?.id || 0)
    return record
  }
  @POST('/bulk-create')
  async createMany(@Body() body: { data: Omit<D, 'id'>[] } & Record<string, any>): Promise<{ count: number }> {
    const records = await (this.service as unknown as any).createMany(body.data || [])
    return records
  }
  @POST('')
  async createOne(@Body() body: Omit<D, 'id'>): Promise<D> {
    const record = await (this.service as unknown as any).createOne(body)
    return record
  }
  @PUT(':id')
  async updateOne(@Params() params: any, @Body() body: Partial<D>): Promise<{ count: number }> {
    const record = await (this.service as unknown as any).updateOne(+params?.id || 0, body)
    return record
  }
  @PUT()
  async updateMany(@Body() body: any): Promise<{ count: number }> {
    const records = await (this.service as unknown as any).updateMany(body)
    return records
  }
  @DELETE(':id')
  async deleteOne(@Params() params: any): Promise<D> {
    const record = await (this.service as unknown as any).deleteOne(+params?.id || 0)
    return record
  }

  @DELETE()
  async deleteMany(@Body() body: any): Promise<{ count: number }> {
    const records = await (this.service as unknown as any).deleteMany(body)
    return records
  }
}

import { User } from '@prisma/client'
import { AppContainer, Body, Controller, Injectable, POST, Query } from '@thoaiky1992/http-server'
import { CrudController } from '~/core/crud/crud-controller'
import UserService from '~/services/user.service'

@Injectable()
@Controller('users')
export default class UserController extends CrudController<UserService, User> {
  constructor() {
    super(AppContainer.resolve(UserService))
  }

  @POST('/get-many-with-conditions')
  async getManyWithConditions(@Body() body: any, @Query() query: any) {
    const users = await super.getMany({ ...query, ...body })
    return users
  }
}

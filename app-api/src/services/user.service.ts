import { User } from '@prisma/client'
import { CrudService, ICommonService } from '~/core/crud/crud-service'
import { Models, TUserModel } from '~/core/prima-client'

export default class UserService extends CrudService<TUserModel, User> implements ICommonService {
  static _instance: UserService
  name: string
  constructor() {
    super(Models.User)
    this.name = UserService.name
  }
}

import { Role } from '@prisma/client'
import { CrudService, ICommonService } from '~/core/crud/crud-service'
import { Models, TRoleModel } from '~/core/prima-client'

export default class RoleService extends CrudService<TRoleModel, Role> implements ICommonService {
  static _instance: RoleService
  name: string
  constructor() {
    super(Models.Role)
    this.name = RoleService.name
  }
}

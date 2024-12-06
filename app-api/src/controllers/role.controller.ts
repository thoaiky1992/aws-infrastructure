import { Role } from '@prisma/client'
import { AppContainer, Injectable } from '@thoaiky1992/http-server/dist/container'
import { Controller } from '@thoaiky1992/http-server/dist/http-server'
import { CrudController } from '~/core/crud/crud-controller'
import RoleService from '~/services/role.service'

@Injectable()
@Controller('/roles')
export default class RoleController extends CrudController<RoleService, Role> {
  constructor() {
    super(AppContainer.resolve(RoleService))
  }
}

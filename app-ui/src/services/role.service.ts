import { CrudService } from "./crud.service";
import { TRole } from "@/models/role.model";

class RoleServiceInstance extends CrudService<TRole> {
  static _instance: RoleServiceInstance;
  constructor() {
    super("roles");
  }
  static get instance() {
    return this._instance || (this._instance = new this());
  }
}
export const RoleService = RoleServiceInstance.instance;

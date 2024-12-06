import { TUser } from "@/models/user.model";
import { CrudService, HttpResponseMultiData } from "./crud.service";

class UserServiceInstance extends CrudService<TUser> {
  static _instance: UserServiceInstance;
  constructor() {
    super("users");
  }
  static get instance() {
    return this._instance || (this._instance = new this());
  }

  async getManyWithConditions(conditions: any): Promise<HttpResponseMultiData<TUser>> {
    try {
      const response = await this.axios.post(
        `/${this.table}/get-many-with-conditions`,
        conditions,
        {
          ...this.axiosRequestConfig,
        }
      );
      return { ...response.data };
    } finally {
      this.axiosRequestConfig = {};
    }
  }
}
export const UserService = UserServiceInstance.instance;

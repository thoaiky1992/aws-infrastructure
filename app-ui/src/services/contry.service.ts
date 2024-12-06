import { TCountry } from "@/models/country.model";
import { CrudService } from "./crud.service";

class CountryServiceInstance extends CrudService<TCountry> {
  static _instance: CountryServiceInstance;
  constructor() {
    super("countries");
  }
  static get instance() {
    return this._instance || (this._instance = new this());
  }
}
export const CountryService = CountryServiceInstance.instance;

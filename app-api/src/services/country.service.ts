import { Country } from '@prisma/client'
import { CrudService, ICommonService } from '~/core/crud/crud-service'
import { Models, TCountryModel } from '~/core/prima-client'

export default class CountryService extends CrudService<TCountryModel, Country> implements ICommonService {
  static _instance: CountryService
  name: string
  constructor() {
    super(Models.Country)
    this.name = CountryService.name
  }
}

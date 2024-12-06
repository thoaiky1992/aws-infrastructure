import { Country } from '@prisma/client'
import { AppContainer, Controller, Injectable } from '@thoaiky1992/http-server'
import { CrudController } from '~/core/crud/crud-controller'
import CountryService from '~/services/country.service'

@Injectable()
@Controller('/countries')
export default class CountryController extends CrudController<CountryService, Country> {
  constructor() {
    super(AppContainer.resolve(CountryService))
  }
}

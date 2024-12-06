import { TCountry } from "./country.model";
import { TRole } from "./role.model";

export type TUser = {
  id: number;
  username: string;
  email: string;
  active: boolean;
  roleId: number;
  role?: TRole;
  countryId: number;
  country?: TCountry;
  description?: string;
};

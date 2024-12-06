import { PrismaClientInstance } from '.'

export enum Models {
  Role = 'role',
  Country = 'country',
  User = 'user'
}

export type TUserModel = typeof PrismaClientInstance.instance.prisma.user
export type TRoleModel = typeof PrismaClientInstance.instance.prisma.role
export type TCountryModel = typeof PrismaClientInstance.instance.prisma.country

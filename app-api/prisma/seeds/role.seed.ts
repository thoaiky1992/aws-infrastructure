import { PrismaClient } from '@prisma/client'

export const roleSeed = async (prisma: PrismaClient) => {
  await prisma.role.createMany({ data: [{ name: 'SUPPER_ADMIN' }, { name: 'ADMIN' }, { name: 'USER' }] })
  const roles = await prisma.role.findMany()
  return roles
}

import { PrismaClient } from '@prisma/client'

export const countrySeed = async (prisma: PrismaClient) => {
  await prisma.country.createMany({ data: [{ name: 'VIET_NAM' }, { name: 'TOKYO' }, { name: 'SINGAPORE' }] })
  const countries = await prisma.country.findMany()
  return countries
}

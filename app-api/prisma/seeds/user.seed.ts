import { faker } from '@faker-js/faker'
import { Country, PrismaClient, Role } from '@prisma/client'

const getRandomOfList = <T>(list): T => {
  const randomIndex = Math.floor(Math.random() * list.length)
  return list[randomIndex]
}
export const userSeed = async (prisma: PrismaClient, roles: Role[], countries: Country[]) => {
  await prisma.user.createMany({
    data: Array.from({ length: 5 }, (_, index) => index + 1).map((item, i) => ({
      email: faker.internet.email(),
      username: faker.internet.username(),
      roleId: getRandomOfList<Role>(roles).id,
      countryId: getRandomOfList<Country>(countries).id,
      active: item % 2 === 0,
      createdAt: new Date(new Date().setMinutes(new Date().getMinutes() + i))
    }))
  })
}

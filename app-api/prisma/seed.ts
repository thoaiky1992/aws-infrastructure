import { PrismaClient } from '@prisma/client'
import { roleSeed } from './seeds/role.seed'
import { countrySeed } from './seeds/country.seed'
import { userSeed } from './seeds/user.seed'
const prisma = new PrismaClient()
async function main() {
  const [roles, countries] = await Promise.all([roleSeed(prisma), countrySeed(prisma)])
  userSeed(prisma, roles, countries)
}
main()
  .then(async () => {
    await prisma.$disconnect()
  })
  .catch(async (e) => {
    console.error(e)
    await prisma.$disconnect()
    process.exit(1)
  })

#!/bin/bash

npx prisma migrate deploy && npx prisma generate && npm run prisma:seed
# Stage 1: Base - Install dependencies and build the app
FROM node:20.11.1

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .
COPY .env.prod .env
COPY entry-point.sh ./entry-point.sh

# Ensure entry-point.sh is executable
RUN chmod +x ./entry-point.sh

# Generate Prisma Client for interacting with the database
RUN npx prisma generate

# Build the application
RUN npm run build

# Set environment variables
ENV NODE_ENV=production

# Run the entry-point script and start the application
CMD ["sh", "-c", "./entry-point.sh && npm run start"]

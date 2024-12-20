# Stage 1: Install dependencies and build the app
FROM node:20.11.1 AS builder

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application
COPY . .

# Build the application
RUN npm run build

# Stage 2: Run the app in production
FROM node:20.11.1

# Set the working directory
WORKDIR /app

# Copy the built application and necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public 
COPY --from=builder /app/.example.env ./.env
COPY --from=builder /app/node_modules ./node_modules

# Set environment variables
ENV NODE_ENV=production

# Expose the port Next.js will run on
EXPOSE 3000
# Start the application
CMD [ "npm", "start" ]

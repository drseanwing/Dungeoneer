FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
RUN yarn remove sharp && yarn add sharp
COPY . .
RUN npm run buildlinux   # Explicit Linux build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app ./
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 3000
CMD ["yarn", "start"]

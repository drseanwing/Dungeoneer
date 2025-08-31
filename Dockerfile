FROM node:18-alpine AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build # if applicable, or `yarn install && yarn start`

FROM node:18-alpine AS runtime
WORKDIR /app
COPY --from=builder /app ./
# Drop privileges: use a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
EXPOSE 3000
CMD ["yarn", "start"]

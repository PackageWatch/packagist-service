# Development Environment
FROM node:12-alpine as development

WORKDIR /app

COPY package* ./

RUN npm ci --prefer-offline --no-audit

COPY . .

RUN npm run build


# Run Tests
FROM node:12-alpine as test-runner

COPY --from=development /app /app

WORKDIR /app

RUN npm test

# Build Production Image
FROM node:12-alpine as stable

WORKDIR /app

COPY --from=development /app/dist ./dist

COPY package* ./

RUN npm ci --prefer-offline --no-audit --production

CMD ["npm", "start"]
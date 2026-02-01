FROM node:22-bookworm AS builder
WORKDIR /app
RUN corepack enable
COPY . .
RUN pnpm install --frozen-lockfile
RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build
RUN pnpm ui:build

FROM node:22-bookworm
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/node_modules ./node_modules
RUN apt-get update && apt-get install -y curl && curl -fsSL https://tailscale.com/install.sh | sh
USER root
CMD ["node", "dist/index.js"]

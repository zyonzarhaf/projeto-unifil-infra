FROM node:20-alpine AS frontend-build
ARG VITE_API_BASE
ENV VITE_API_BASE=$VITE_API_BASE
WORKDIR /app
COPY --from=frontend package*.json ./
RUN npm ci
COPY --from=frontend ./ ./
RUN npm run build

FROM caddy:alpine
COPY --from=frontend-build /app/dist /srv

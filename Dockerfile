FROM node:12-alpine as build
ARG BUILD_DIR=rs-cart-api
RUN mkdir -p ${BUILD_DIR}
# Copy project files
COPY . /${BUILD_DIR}
WORKDIR /${BUILD_DIR}
# Install dependencies
RUN npm i
RUN npm run build --prod --outputPath=./dist

FROM node:12-alpine as production
ARG PROD_DIR=rs-cart-build
RUN mkdir -p ${PROD_DIR}
RUN mkdir -p ${PROD_DIR}/dist
# Copy dist and package from stage 1
COPY --from=build /rs-cart-api/dist/ /${PROD_DIR}/dist
COPY --from=build /rs-cart-api/package*.json /${PROD_DIR}/
WORKDIR /${PROD_DIR}
# Install prod dependencies
RUN npm install --production
EXPOSE 4000
CMD ["node", "dist/main"]

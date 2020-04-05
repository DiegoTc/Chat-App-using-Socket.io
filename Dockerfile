FROM node:12.16.1-buster
WORKDIR /app
COPY . /app
RUN npm install
EXPOSE 5000
CMD ["npm","start"]

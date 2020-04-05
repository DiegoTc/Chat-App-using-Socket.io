FROM node
WORKDIR /app
RUN cd /app
COPY . /app
RUN npm install
EXPOSE 5000
CMD ["npm","start"]

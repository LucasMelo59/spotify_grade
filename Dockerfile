# Use uma imagem Node.js como base
FROM node:latest as build-stage

# Configure o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo package.json e package-lock.json para o diretório de trabalho
COPY package*.json ./

# Instale as dependências do projeto
RUN npm install

# Copie todo o código-fonte para o diretório de trabalho
COPY . .

# Execute o comando de build para criar a versão otimizada do aplicativo Vue.js
RUN npm run build

# Configuração do estágio de produção
FROM nginx:latest as production-stage

# Copie o build gerado para o diretório padrão do servidor nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Exponha a porta 80 para permitir que o tráfego entre no contêiner
EXPOSE 80

# Comando para iniciar o servidor nginx
CMD ["nginx", "-g", "daemon off;"]


#como rodar o projeto com docker e nginx
# use: docker build -t meu-app-vue .
# em seguida docker run -p 3000:80 meu-app-vue

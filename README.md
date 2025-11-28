This is a full-stack MEAN application with automated CI/CD pipeline using Jenkins, Docker, Docker Hub, AWS EC2 & S3.

Backend: Node.js + Express.js providing REST APIs connected to MongoDB

Frontend: Angular 15 with HTTPClient for API communication

Features:

Create, Read, Update, Delete tutorials

Search tutorials by title

Deployed frontend via S3

Backend hosted on EC2 behind Nginx reverse proxy

crud-dd-task-mean-app/
├── backend/
│   ├── Dockerfile
│   ├── server.js
│   └── app/config/db.config.js
├── frontend/
│   ├── Dockerfile
│   └── src/app/services/tutorial.service.ts
├── deployment/
│   ├── docker-compose.yml
│   ├── nginx.conf
│   └── deploy.sh
├── Jenkinsfile
└── README.md

🛠 Step-by-Step Setup & Deployment
1️⃣ Backend Setup (Node.js + Express)
cd backend
npm install
# Update MongoDB credentials in app/config/db.config.js
node server.js
API Endpoint: http://localhost:8080/api/tutorials

2️⃣ Frontend Setup (Angular)
cd frontend
npm install
ng serve --port 8081
UI URL: http://localhost:8081/
Modify src/app/services/tutorial.service.ts to adjust backend API if require

3️⃣ Dockerization
Backend Image:
cd backend
docker build -t <dockerhub-username>/mean-backend .
docker push <dockerhub-username>/mean-backend


Frontend Image:
cd frontend
docker build -t <dockerhub-username>/mean-frontend .
docker push <dockerhub-username>/mean-frontend

4️⃣ Deployment on Cloud VM (Ubuntu EC2)
Install Docker & Docker Compose
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker


Deploy Application
cd deployment
docker-compose pull
docker-compose up -d --force-recreate
docker ps

5️⃣ Nginx Reverse Proxy Configuration
server {
    listen 80;

    location /api/ {
        proxy_pass http://backend:8080/;
    }

    location / {
        proxy_pass http://frontend:80/;
    }
}


Reload Nginx:
sudo nginx -t
sudo systemctl restart nginx

🔄 CI/CD Pipeline (Jenkins)
Pipeline Stages:
Stage	Action
Checkout	Pull latest code from GitHub
Build Backend	npm install + Docker build
Build Frontend	npm install + Angular production build
Push Images	Docker login → push images to Docker Hub
Deploy to VM	SSH → Pull images → Docker Compose up
Upload Frontend	S3 sync for Angular UI


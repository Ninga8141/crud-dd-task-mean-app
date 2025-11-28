This is a full-stack MEAN application with automated CI/CD pipeline using Jenkins, Docker, Docker Hub, AWS EC2 & S3.

Backend: Node.js + Express.js providing REST APIs connected to MongoDB

Frontend: Angular 15 with HTTPClient for API communication

Features:

Create, Read, Update, Delete tutorials

Search tutorials by title

Deployed frontend via S3

Backend hosted on EC2 behind Nginx reverse proxy

crud-dd-task-mean-app/
![image alt](https://github.com/Ninga8141/crud-dd-task-mean-app/blob/2b8109f593c19f6d8a9db7304510a8e195f83f4e/Screenshots/App-Directory%20structures.png)

🛠 Step-by-Step Setup & Deployment
1️⃣ Backend Setup (Node.js + Express)
cd backend
npm install
# Update MongoDB credentials in app/config/db.config.js
node server.js
API Endpoint: http://localhost:8080/api/tutorials
![image alt](https://github.com/Ninga8141/crud-dd-task-mean-app/blob/99007101c82ea277b8b2008a5943fd54e27985b1/Screenshots/API%20Test.png)

2️⃣ Frontend Setup (Angular)
cd frontend
npm install
ng serve --port 8081
UI URL: http://localhost:8081/
Modify src/app/services/tutorial.service.ts to adjust backend API if require
![image alt](https://github.com/Ninga8141/crud-dd-task-mean-app/blob/134998bef9f1b322402396eea0a7ce13a64b1828/Screenshots/Frondend%20UI%20Tested.png)

3️⃣ Dockerization
Backend Image:
cd backend
docker build -t <dockerhub-username>/mean-backend .
docker push <dockerhub-username>/mean-backend
![image alt](https://github.com/Ninga8141/crud-dd-task-mean-app/blob/2b8109f593c19f6d8a9db7304510a8e195f83f4e/Screenshots/Docker%20image%20build%20and%20push%20process..png)


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


CI/CD Process
1. Continuous Integration (CI)

Code Commit: Developers push code to the main branch or feature branches.

Build Trigger: A CI tool (e.g., Jenkins, GitHub Actions, GitLab CI) automatically triggers a build.

Dependencies Installation: Installs project dependencies (npm install for Node.js).

Code Linting & Testing:

Runs linter to ensure code quality

Executes automated tests (npm test)

Build Artifacts: Builds the application (e.g., npm run build) if tests pass.

2. Continuous Deployment/Delivery (CD)

Artifact Storage: Build artifacts are stored in a repository or storage bucket.

Deployment Trigger: Upon successful build, deployment pipeline starts automatically.

Deployment Steps:

Backend deployed to server/container (e.g., Node.js app on Ubuntu VM or Docker container)

Frontend deployed to static hosting (e.g., S3 bucket, Netlify, Vercel)

Post-Deployment Tests: Ensures application is running correctly (smoke tests).

3. Tools Used
Stage	Tool / Technology
CI	Jenkins / GitHub Actions / GitLab CI
Build & Test	Node.js, npm, Mocha/Jest
Deployment	Docker, AWS EC2, S3, Nginx
Version Control	Git, GitHub


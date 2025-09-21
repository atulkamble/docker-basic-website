// docker website hosting project 
```
1. create a repo on github docker-basic-website
2. maintain website under site folder as a index.html
3. write Dockerfile 

ref: https://github.com/atulkamble/docker-basic-website

OR clone code

4. git clone https://github.com/atulkamble/docker-basic-website.git
cd docker-basic-website

5. 
sudo docker build -t atuljkamble/docker-basic-website .
sudo docker images
sudo docker login 
sudo docker push atuljkamble/docker-basic-website

sudo docker run -d -p 80:80 atuljkamble/docker-basic-website

6. access website on http://vm-public-ip
```

# Dummy
This is a sample NodeJS app which prints hello world and inserts a value in DB.

Pre-req:
Docker image built and pushed to avsprashant/nodeapp repo. Application file is index.js only.
minikube start # start cluster first

Deployment Steps:

mkdir WORKDIR && cd WORKDIR; 

git clone https://github.com/avsprashant/Dummy.git    # clone my repo

cd Dummy/

sh startUpScript.sh 
# This will create all objects in this order :
Secret kind object from secrets.yml stores base 64 encrypted DB passwords, 

PersistentVolume kind object from  mysql-pv.yaml which creates a 20GB volume block at /mnt/data/

PersistentVolumeClaim kind object from  mysql-pv.yaml defines a volume mount for /var/lib/mysql at above volume,

Pod kind object from database.yml creates a DB from this mysql:5.7 image,

Service kind object from database-service.yml exposes above POD,

Deployment kind object from helloworld-db.yml which is our app layer and 

Service kind object from helloworld-db-service.yml generic object exposing above Deployment object.

# Verification of deployed services:
kubectl get service   # check services which get created instantly

kubectl get pods      # check pods status, they will take sometime as they have to pull image and deploy

kubectl describe deployment <helloworld-deployment-randomString>  # We have defined 2 replicas, describe for one of the deployment.

kubectl logs <helloworld-deployment-randomString>   # view our NodeJs app prints logs here

minikube service helloworld-db-service --url    # we get a end point as url

curl <URL>  # curl should be installed, else try to do telnet and port

## This should give hello world and visitor count. Our App is accessible from outside cluster i.e HOST.

# Verification of App and DB authentication:
1)

kubectl exec database -it -- mysql -u root -p     # give password - "rootpassword"
In mysql prompt, enter 
show databases;
use helloworld;       #helloworld is our DB
select * from views;  #views is our table, you should see some data.

2)

du -s /mnt/data/    # make a note of DB space utilized
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255) 
);
insert into Persons(PersonID) values(100); # Add some sample data and again check DB space utilized

# Verification of Data persistence @ /mnt/data/ in Host:
kubectl exec database -- touch /var/lib/mysql/abc.txt # create a file in DB pod

ls -l /mnt/data/abc.txt # access it on HOST @ /mnt/data/

Data is getting stored in /var/lib/mysql which is inturn mounted at /mnt/data/

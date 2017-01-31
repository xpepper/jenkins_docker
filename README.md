# A Jenkins instance with docker pre-installed to have a build pipeline which builds docker images

## Prerequisites
Docker

## Build the image
```
docker build -t <my-username>/jenkins_docker .
```

## Run Jenkins
```
mkdir -p  $(pwd)/data/jenkins
docker run --privileged -p 8080:8080 -p 50000:50000 -v $(pwd)/data/jenkins:/var/jenkins_home <my-username>/jenkins_docker
```

## Configure Jenkins
Go to http://localhost:8080 and start configuring Jenkins.

* Install the "Blue Ocean" plugin to have a new shining layout :)

### Configure Maven
Go to [http://localhost:8080/configureTools/](http://localhost:8080/configureTools/) and add Maven (use the name: 'M3').

### Add your credentials to Jenkins
Add your credentials to Jenkins (e.g. `pierodibello-login`) to be able to push your images to a public docker registry (just for example).

### Create the job
Finally, create a new `Pipeline Job` with this groovy script

```
node {
   def mvnHome
   stage('Preparation') {
      git 'https://github.com/pdincau/employee_admin.git'
      mvnHome = tool 'M3'
   }
   stage('Build') {
      sh "'${mvnHome}/bin/mvn' clean package"
   }
   stage('Bake Image') {
      docker.withRegistry('https://registry.hub.docker.com', 'pierodibello-login') {
          def newApp = docker.build("pierodibello/employee_admin:${env.BUILD_NUMBER}")
          newApp.push()
      }
   }
}
```

### Run the app
After almost one build, you can try out the demo app (just for fun):

```
 docker exec -it <image_hash> /bin/sh
 docker run -p 8081:8080 <image_name>:<tag>
```

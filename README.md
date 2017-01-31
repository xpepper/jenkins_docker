# A Jenkins instance with docker pre-installed to have a build pipeline which builds docker images

### Prerequisites
Docker

### Build the image
```
docker build -t <my-username>/jenkins_docker .
```

### Run Jenkins
```
mkdir -p  $(pwd)/data/jenkins
docker run --privileged -p 8080:8080 -p 50000:50000 -v $(pwd)/data/jenkins:/var/jenkins_home <my-username>/jenkins_docker
```

### Configure Jenkins
Go to http://localhost:8080 and start configuring Jenkins.

* Install the "Blue Ocean" plugin to have a new shining layout :)

Go to http://localhost:8080/configureTools/ and add Maven ('M3')
Create a new Pipeline Job with this script

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
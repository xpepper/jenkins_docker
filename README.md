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
Go to [Global Tool Configuration](http://localhost:8080/configureTools/) and add Maven (use the name: 'M3').

### Add your credentials to Jenkins
Add your credentials to Jenkins (e.g. `pierodibello-login`) to be able to push your images to a public docker registry (just for example).
Go to [http://localhost:8080/credentials/store/system/](http://localhost:8080/credentials/store/system/), then click on "Add credentials".

### Create the job
Finally, create a new `Pipeline` job with the groovy script in the `Jenkinsfile`

### Run the app
After almost one build, you can try out the demo app (just for fun), so connect to the docker image running Jenkins, and the from there run one of the baked images:

```
 docker exec -it <CONTAINER_ID> /bin/sh
 docker run -p 8081:8080 <IMAGE_ID>
```

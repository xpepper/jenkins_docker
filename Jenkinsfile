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

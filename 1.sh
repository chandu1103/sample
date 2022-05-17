pipeline {
     agent any
     stages {
         stage (cloning) {
             steps {
                 script{
                 git branch: 'ansible', url: 'https://github.com/chandu1103/sample.git' 
                 env.PRIVATE_IP = input message: 'PLEASE ENTER THE PRIVATE IP',
                 parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'PRIVATE_IP')]
                }
             }
         }
          stage(inventory_file_updating){
              steps{
                  script{
                    sh '''
                       cat << EOF > inventory
                       [docker]
                       $PRIVATE_IP


                       [all:vars]
                       ansible_user: ubuntu
                    EOF
                     '''
                  }
              }
          }
          stage(ansible_docker) {
             steps {
                 script{
                        env.INPUT = input message: 'DO YOU WANT TO INSTALL DOKCER (yes/no)',
                        parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'INPUT')]
                        if ($INPUT == "yes") {
                                              ansiblePlaybook colorized: true, credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible2', inventory: 'inventory', playbook: 'docker.yaml'
                                             }
                        else{
                             sh 'exit 0'
                            
                             }
                        
                        }  
                   }
            }
        }:wq

}

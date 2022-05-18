pipeline {
    agent any
    parameters {
                gitParameter branchFilter: 'origin/(.*)', defaultValue: 'main', name: 'Branch', type: 'PT_BRANCH'
              }

    stages {
    stage('Cloning the Project'){
        steps{
            script{
                try{
                    def cause = currentBuild.getBuildCauses('hudson.model.Cause$UserIdCause')
                    slackSend (botUser: true, color: 'good', message: "Cloning the Project- nodejs-Branch-${Branch}: Job '${env.JOB_NAME} ${cause.userName} [${env.BUILD_NUMBER}]'" , channel: "test", teamDomain: 'chandu1607', tokenCredentialId: 'slack')
                    echo "flag: ${params.Branch}"
                    git branch: "${params.Branch}",  url: 'https://github.com/chandu1103/sample.git'
                   }
                catch(Exception e){
                    echo "FAILED ${e}"
                    slackSend(botUser: true, channel: 'test', color: 'danger', message: '"Failed at Cloning the Project- nodejs: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}]@Burra Chandu0304"', teamDomain: 'chandu1607', tokenCredentialId: 'slack')
                    currentBuild.result = 'FAILURE'
                    throw e
                   }   
                  }
            }
        }
    stage (inventory_file_updating) {
        steps{
            script{
                try {
                    echo "${PRIVATE_IP}"
                    sh '''
                    cat << EOF > nagios-nrpe/inventory
                    [webservers]
                    ${PRIVATE_IP}

                    [all:vars]
                    ansible_user: ubuntu
                     '''
                    slackSend(botUser: true, channel: 'test', color: 'good', message: '"UPDATED REMOTE HOST ADDRESS"' , teamDomain: 'chandu1607', tokenCredentialId: 'slack')
                    }
                catch(Exception e){
                    echo "FAILED ${e}"
                    slackSend(botUser: true, channel: 'test', color: 'danger', message: '"Failed at updating the remote host ip"', teamDomain: 'chandu1607', tokenCredentialId: 'slack')
                    currentBuild.result = 'FAILURE'
                    throw e
                    }  
                   }
            }

        }

    stage( updating_nrpe_cfg_file ){
        steps {
            script{
                sh '''
                cd nagios-nrpe
                sed -i '/allowed_hosts/d' nrpe.cfg

                cat << EOF >>  nrpe.cfg
\n 
# adding allowed hosts
allowed_hosts= ${PRIVATE_IP}
                       '''
                }
              }
         }
    }
}


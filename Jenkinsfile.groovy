pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git branch: 'develop',
                    url: 'https://github.com/Sukpanitada/TTB_ROBOT.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    if [ ! -d myvenv ]; then
                        python3 -m venv myvenv
                    fi

                    source myvenv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('API Test') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                sh '''
                    source myvenv/bin/activate
                    robot -v ENV=sit -d reports/api testcases/api
                '''
}
            }
        }
        
        stage('Web Test') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                sh '''
                    source myvenv/bin/activate
                    robot -v ENV=sit -d reports/web testcases/web
                '''
                }
            }
        }
        
        stage('Mobile Test') {
            steps {
                catchError(buildResult: 'UNSTABLE', stageResult: 'FAILURE') {
                sh '''
                    source myvenv/bin/activate
                    robot -v ENV=sit -d reports/mobile testcases/mobile
                '''
            }
            }
        }


        stage('Merge') {
            steps {
                sh '''
                    source myvenv/bin/activate

                    FILES=""
                    [ -f reports/api/output.xml ] && FILES="$FILES reports/api/output.xml"
                    [ -f reports/web/output.xml ] && FILES="$FILES reports/web/output.xml"
                    [ -f reports/mobile/output.xml ] && FILES="$FILES reports/mobile/output.xml"

                    python -m robot.rebot --name "TTB Automation SIT" --output output.xml $FILES
                '''
            }
} 
    }

    post {
        always {

            archiveArtifacts(
                artifacts: 'reports/**/*.html,reports/**/*.xml,output.xml',
                allowEmptyArchive: true
            )

            script {
                if (fileExists('output.xml')) {
                    robot(
                        outputPath: '.',
                        outputFileName: 'output.xml',
                        reportFileName: 'report.html',
                        logFileName: 'log.html'
                    )
                }
            }
        }
    }
}
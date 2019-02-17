#!/usr/bin/env groovy

env.GF_SMTP_ENABLED = true

node('armv7l') {

  try {

    stage('build') {
      deleteDir()
      checkout scm
      sh "make"
    }

    stage('push') {
      sh "make push"
    }

  } catch(error) {
    throw error

  } finally {
    deleteDir()
  }
}

node('manager') {

  try {
    stage('scm') {
      deleteDir()
      checkout scm
    }

    stage('deploy') {
      withCredentials([
        usernamePassword(credentialsId: 'gf-db-creds',
          usernameVariable: 'GF_DATABASE_USER',
          passwordVariable: 'GF_DATABASE_PASSWORD'),
        usernamePassword(credentialsId: 'gf-smtp-creds',
          usernameVariable: 'GF_SMTP_USER',
          passwordVariable: 'GF_SMTP_PASSWORD'),
        string(credentialsId: 'gf-smtp-host',
          variable: 'GF_SMTP_HOST'),
        string(credentialsId: 'gf-db-host',
          variable: 'GF_DATABASE_HOST')]) {
        sh "make deploy"
      }
    }

  } catch(error) {
    throw error

  } finally {
    deleteDir()
  }
}

Feature: Backup and restore database

  Scenario: Setup machine
    When I setup machine
    Then it should be successful
    And automysqlbackup should exist
    And automysqlbackup config file should be edited
    And rsync should exist
    And pip should exist
    And boto should exist
    And awscli should be present
    And .aws folder should be present
    And awscli config file should be present
    And awscli credentials file should be present

  Scenario: Create S3 bucket
    When I create S3 bucket
    Then it should be successful
    And S3 bucket should exist
  
  Scenario: Install mysql workbecnh
    When I install mysql workbench
    Then it should be successful
    And mysqlworkbench should exist

  Scenario: Create backup directory
    When I create sysbackup directory
    Then it should be successful
    And sysbackup directory should exist

  Scenario: Create backup cron job
    When I add backup crontab file
    Then it should be successful
    And backup job should exist

  Scenario: Create backup script
    When I create backup script
    Then it should be successful
    And backup.sh script should exist
 
    
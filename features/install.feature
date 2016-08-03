Feature: Backup and restore database

  Scenario: Setup machine
    When I setup machine
    Then it should be successful
    And automysqlbackup should exist
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

  Scenario: Create restore directory
    When I create restore directory
    Then it should be successful
    And restore directory should exist

  Scenario: Create restore cron job
    When I add confirm_backup crontab file
    Then it should be successful
    And confirm_backup job should exist

  Scenario: Create restore script
    When I create confirm_backups script
    Then it should be successful
    And confirm_backups.sh script should exist

  Scenario: Confirming backups
    When I check for difference in backup and source directory
    Then it should be successful
    And exit code should be 0
    
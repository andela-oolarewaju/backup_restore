require 'open3'
require_relative 'vars.rb'

When(/^I setup machine$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'setup'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^automysqlbackup should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'dpkg --get-selections | grep automysqlbackup'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("automysqlbackup")
end

And(/^automysqlbackup config file should be edited$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'cat /etc/default/automysqlbackup  | grep 'CREATE_DATABASE''"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to include("CREATE_DATABASE=no")
end

And(/^rsync should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'dpkg --get-selections | grep rsync'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("rsync")
end

And(/^pip should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'pip --version | grep pip'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("pip")
end

And(/^boto should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'pip freeze | grep boto==*'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("boto==")
end

And(/^awscli should be present$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'aws --version 2>&1 | grep aws-cli*'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("aws-cli")
end

And(/^.aws folder should be present$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls -al /root/ | grep .aws'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include(".aws")
end

And(/^awscli config file should be present$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /root/.aws | grep config'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("config")
end

And(/^awscli credentials file should be present$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /root/.aws | grep credentials'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("credentials")
end

When(/^I create S3 bucket$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'find_bucket,create_bucket'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^S3 bucket should exist$/) do
  cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'find_bucket'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
end

When(/^I install mysql-utilities$/) do
  cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'mysql_utilities'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^mysql-utilities should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'dpkg --get-selections | grep mysql-utilities'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("mysql-utilities")
end


When(/^I create sysbackup directory$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'backup_file'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^sysbackup directory should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /home/ubuntu | grep sysbackup'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to include("sysbackup")
end

When(/^I add backup crontab file$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_cron_file'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^backup job should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'ls /etc/cron.d/ | grep backup'"
  output, error, status = Open3.capture3 "#{cmd}"

  expect(status.success?).to eq(true)
  expect(output).to match("backup")
end

When(/^I create backup script$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_backup_script'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^backup.sh script should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /home/ubuntu | grep backup.sh'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("backup.sh")
end

When(/^I create restore script$/) do
  cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_restore_script'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^restore.sh script should exist$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /home/ubuntu | grep restore.sh'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("restore.sh")
end


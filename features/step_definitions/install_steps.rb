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

When(/^I create sysbackup directory$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'backup_file'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create restore directory$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'restore_dir'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^([^"]*) directory should exist$/) do |directory|
  case directory
  when 'sysbackup', 'restore'
	  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /home/ubuntu | grep #{directory}'"
	  output, error, status = Open3.capture3 "#{cmd}"
	  expect(status.success?).to eq(true)
	  expect(output).to include("#{directory}")
  else
    raise 'Not Implemented'
  end
end

When(/^I add backup crontab file$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_cron_file'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I add confirm_backup crontab file$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_restore_file'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^([^"]*) job should exist$/) do |job|
  case job
  when 'backup', 'confirm_backup'
	  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'ls /etc/cron.d/ | grep #{job}'"
	  output, error, status = Open3.capture3 "#{cmd}"

	  expect(status.success?).to eq(true)
	  expect(output).to match("#{job}")
	else
    raise 'Not Implemented'
  end
end

When(/^I create backup script$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_backup_script'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create confirm_backups script$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'copy_confirm_script'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^([^"]*) script should exist$/) do |script|
  case script
  when 'backup.sh', 'confirm_backups.sh'
	  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo ls /home/ubuntu | grep #{script}'"
	  output, error, status = Open3.capture3 "#{cmd}"
	  expect(status.success?).to eq(true)
	  expect(output).to match("#{script}")
	else
    raise 'Not Implemented'
  end
end

When(/^I check for difference in backup and source directory$/) do
	cmd = "ansible-playbook -i inventory.ini playbook.main.yml --tags 'confirm_backup'"
	output, error, @status = Open3.capture3 "#{cmd}"
end

And(/^exit code should be 0$/) do
  cmd = "ssh -i '#{PATHTOPRIVATEKEY}' #{PUBDNS} 'sudo cat /home/ubuntu/tmp.txt'"
  output, error, status = Open3.capture3 "#{cmd}"
  expect(status.success?).to eq(true)
  expect(output).to match("0")
end








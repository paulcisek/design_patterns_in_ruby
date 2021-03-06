OldiesDir = 'oldies'
NewiesDir = 'newies'

BackupDir = 'backup'

timestamp=Time.new.to_s.tr(" :", "_")

task :default => [:backup_oldies, :backup_newies]

task :backup_oldies do
	backup_dir = File.join(BackupDir, timestamp, OldiesDir)
	mkdir_p File.dirname(backup_dir)
	cp_r OldiesDir, backup_dir
end

task :backup_newies do
	backup_dir = File.join(BackupDir, timestamp, NewiesDir)
	mkdir_p File.dirname(backup_dir)
	cp_r NewiesDir, backup_dir
end
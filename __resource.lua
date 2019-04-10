 -- Police System --
-- Made By Chezza --

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'cl_polsystem.lua',
    'warmenu.lua'
 }
 
 server_scripts {
    'sv_polsystem.lua',
    '@mysql-async/lib/MySQL.lua'
 }
-- Autostart applications *once* at startup
autorun = true
autorun_apps =
{
  -- cmd is required, the rest is optional. 
  { cmd="nm-applet", },

  -- Args are supported as well.
  { cmd="xrdb", args="~/.Xdefaults"},

  -- If more than one arg, just append it to the args string, like so: 
  -- args="--restore --verbose --pony"
  { cmd="nitrogen", args="--restore" },

  -- nextcloud-client is the startup script, but the program is nextcloud once 
  -- running, hence this target argument. We will check if there's a program called
  -- nextcloud running already, if it isn't we'll start the nextcloud-client script.
  { cmd="nextcloud-client", target="nextcloud" },
}

if autorun then
  -- Run pgrep to see if program is running
  local function pgrep(command)
    -- Adapted from https://stackoverflow.com/a/23833013
    return io.popen('pgrep ' .. command .. ' \necho _$?'):read'*a':match'.*%D(%d+)'+0
  end
  
  for app_index = 1, #autorun_apps do
    local app = autorun_apps[app_index]
    local cmd = app.cmd
    
    -- Use target if there, as for the nextcloud situation above
    if app.target then
      cmd = app.target
    end
    
    -- Check if program runs
    local status = pgrep(cmd)
    
    -- Exit code 1 means the process couldn't be found => probably not running
    if status == 1.0 then
      local command = app.cmd
      
      -- Add args if defined
      if app.args then
        command = command .. " " .. app.args
      end
      
      -- Spawn the process
      awful.util.spawn(command)
      naughty.notify({
        text = cmd .. " started",
        timeout = 3
      })
    end
    
    -- Exit code 2 is invalid syntax, code 3 is a fatal error
    if status == 2.0 then
      naughty.notify({ 
        preset = naughty.config.presets.critical,
        title = "Oops, autostart program syntax error!",
        text = "Program with invalid syntax: " .. cmd
      })
    end
    if status == 3.0 then
      naughty.notify({ 
        preset = naughty.config.presets.critical,
        title = "Oops, fatal error while autostarting!",
        text = "Program causing fatal error: " .. cmd
      })
    end
  end
end
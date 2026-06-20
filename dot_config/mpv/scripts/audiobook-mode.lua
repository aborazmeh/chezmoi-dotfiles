require 'mp.options'

options = {
  persistent_playlist = false,
  pause_on_finish = false,
}

read_options(options)

function pause_on_finish_toggle()
  options.pause_on_finish = not options.pause_on_finish
  if options.pause_on_finish then
    mp.osd_message('Pause at the file EOF', 3)
  else
    mp.osd_message('Continue after reaching EOF', 3)
  end
end


function show_playlist()
  if options.persistent_playlist then
    mp.osd_message(mp.get_property_osd('playlist'), 99999)
  end
end

mp.register_event('file-loaded', function()
  show_playlist()
  mp.add_periodic_timer(10, show_playlist)
end)

mp.register_event('end-file', function()
  if options.pause_on_finish then
    mp.set_property('pause', 'yes')
  end
end)

mp.add_key_binding('shift+P', "pause_on_finish_toggle", pause_on_finish_toggle)

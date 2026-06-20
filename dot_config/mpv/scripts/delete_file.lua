local utils = require("mp.utils")

require("mp.options")

options = {}
options.MoveToFolder = false
options.DeleteOnFinish = false

if package.config:sub(1, 1) == "/" then
  options.DeletedFilesPath = utils.join_path(os.getenv("HOME"), "delete_file")
  ops = "unix"
else
  options.DeletedFilesPath = utils.join_path(os.getenv("USERPROFILE"), "delete_file")
  ops = "win"
end

read_options(options)

del_list = {}

function createDirectory()
  if not utils.file_info(options.DeletedFilesPath) then
    if not os.execute(string.format('mkdir "%s"', options.DeletedFilesPath)) then
      print("failed to create folder")
    end
  end
end

local function work_dir()
  return mp.get_property_native("working-directory")
end

function current_file_path()
  local file_path = mp.get_property_native("path")
  local s = file_path:find(work_dir(), 0, true)
  if s and s == 0 then
    return file_path
  else
    return utils.join_path(work_dir(), file_path)
  end
end

function contains_item(l, i)
  for k, v in pairs(l) do
    if v == i then
      return k
    end
  end
  return false
end

function get_subs()
  local subs = {}
  for _, track in ipairs(mp.get_property_native("track-list")) do
    if track["type"] == "sub" then
      subs[#subs + 1] = track["external-filename"]
    end
  end
  return subs
end

function mark_delete(force)
  local file_key = contains_item(del_list, current_file_path())
  if not file_key then
    table.insert(del_list, current_file_path())
    mp.osd_message("deleting current file")
  elseif not force then
    mp.osd_message("undeleting current file")
    del_list[file_key] = nil
  end

  for _, sub in pairs(get_subs()) do
    local sub_path = utils.join_path(work_dir(), sub)
    local sub_key = contains_item(del_list, sub_path)
    if not sub_key then
      table.insert(del_list, sub_path)
    else
      del_list[sub_key] = nil
    end
  end
end

function delete()
  if options.MoveToFolder then
    --create folder if not exists
    createDirectory()
  end

  for i, v in pairs(del_list) do
    if options.MoveToFolder then
      print("moving: " .. v)
      local _, file_name = utils.split_path(v)
      --this loop will add a number to the file name if it already exists in the directory
      --But limit the number of iterations
      for i = 1, 100 do
        if i > 1 then
          if file_name:find("[.].+$") then
            file_name = file_name:gsub("([.].+)$", string.format("_%d%%1", i))
          else
            file_name = string.format("%s_%d", file_name, i)
          end
        end

        local movedPath = utils.join_path(options.DeletedFilesPath, file_name)
        local fileInfo = utils.file_info(movedPath)
        if not fileInfo then
          os.rename(v, movedPath)
          break
        end
      end
    else
      print("deleting: " .. v)
      os.remove(v)
    end
  end
end

function showList()
  local delString = "Delete Marks:\n"
  for _, v in pairs(del_list) do
    local dFile = v:gsub("/", "\\")
    delString = delString .. dFile:match("\\*([^\\]*)$") .. "; "
  end
  if delString:find(";") then
    mp.osd_message(delString)
    return delString
  elseif showListTimer then
    showListTimer:kill()
  end
end
showListTimer = mp.add_periodic_timer(1, showList)
showListTimer:kill()
function list_marks()
  if showListTimer:is_enabled() then
    showListTimer:kill()
    mp.osd_message("", 0)
  else
    local delString = showList()
    if delString and delString:find(";") then
      showListTimer:resume()
      print(delString)
    else
      showListTimer:kill()
    end
  end
end

function toggle_delete_on_finish()
  options.DeleteOnFinish = not options.DeleteOnFinish
  if options.DeleteOnFinish then
    mp.osd_message("Enable deleting files on finish")
  else
    mp.osd_message("Disable deleting files on finish")
  end
end

function duration_change()
  if not options.DeleteOnFinish then
    return
  end

  local duration = mp.get_property_number("duration")
  local current_time = mp.get_property_number("time-pos")
  local percent_pos = mp.get_property_number("percent-pos")

  if duration ~= nil and duration ~= 0 then
    local remaining = duration - current_time
    if remaining <= 5 then
      mark_delete(true)
    end
  elseif percent_pos ~= nil then
    mark_delete(true)
  end
end

mp.add_key_binding("ctrl+DEL", "delete_file", mark_delete)
mp.add_key_binding("alt+DEL", "list_marks", list_marks)
mp.add_key_binding("ctrl+shift+DEL", "clear_list", function()
  mp.osd_message("Undelete all")
  del_list = {}
end)
mp.add_key_binding("Shift+DEL", "toggle", toggle_delete_on_finish)

mp.register_event("shutdown", delete)

mp.observe_property("percent-pos", "number", duration_change)

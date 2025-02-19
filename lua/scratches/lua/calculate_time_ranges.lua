local function parseTime(timeStr)
  local hours, minutes = timeStr:match("(%d+):(%d+)")
  return tonumber(hours), tonumber(minutes)
end

local function calculateDuration(startTime, endTime)
  local startHour, startMinute = parseTime(startTime)
  local endHour, endMinute = parseTime(endTime)
  return (endHour - startHour) * 60 + (endMinute - startMinute)
end
function calculate_time_ranges()
  local totalTimes = {}
  local currentDate = nil

  -- Получаем текущий буфер
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for _, line in ipairs(lines) do
    line = line:match("^%s*(.-)%s*$")     -- Убираем пробелы в начале и конце

    if line:match("^%d+%.%d+%.%d+$") then
      currentDate = line
      totalTimes[currentDate] = 0
    elseif line:find("%d+:%d+") then
      local startTime, endTime = line:match("(%d+:%d+)%s*%-%s*(%d+:%d+)")
      if startTime and endTime then
        local duration = calculateDuration(startTime, endTime)
        if currentDate then
          totalTimes[currentDate] = totalTimes[currentDate] + duration
        end
      end
    end
  end

  -- Добавляем результаты в конец буфера
  local results = {}
  for date, total in pairs(totalTimes) do
    local hours = math.floor(total / 60)
    local minutes = total % 60
    table.insert(results, string.format("%s: %d ч. %d мин.", date, hours, minutes))
  end

  -- Добавляем результаты в текущий буфер
  vim.api.nvim_buf_set_lines(0, #lines, #lines, false, results)
end


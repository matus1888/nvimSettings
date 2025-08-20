require "nvchad.mappings"
require "scratches.lua.calculate_time_ranges"

local map = vim.keymap.set

map("n", "<leader>F" ,":!prettier --write %<CR>", { desc = "format with global pretiier"} )
map("n", "<leader>ca" ,":lua vim.lsp.buf.code_action()<CR>", { desc = "code actions"} )
map("n", "<leader>oi" ,":lua vim.lsp.buf.execute_command({ command = \"_typescript.organizeImports\", arguments = { vim.api.nvim_buf_get_name(0) } })<CR>",
  { desc = "optimize imports"} )
map("n", "<leader>ct" ,":lua calculate_time_ranges()<CR>", { desc = "calc timescheets"} )
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>cx", function()
  require("nvchad.tabufline").closeAllBufs()
end, { desc = "Close All Buffers" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find Todo" })
map("n", "\\", "<cmd>:vsplit <CR>", { desc = "Vertical Split" })

-- Git
map("n", "<leader>gl", ":Flog<CR>", { desc = "Git Log" })
map("n", "ghu", ":GitGutterUndoHunk<CR>", { desc = "Git hunk reset" })
map("n", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "Git File History" })
map("n", "<leader>gc", ":DiffviewOpen HEAD~1<CR>", { desc = "Git Last Commit" })
map("n", "<leader>gt", ":DiffviewToggleFile<CR>", { desc = "Git File History" })
map("n", "<leader>gh", ":BlameToggle<CR>", { desc = "Git File inline History" })
map("n", "<leader>gk", ":Floggit<CR>", { desc = "Open Commit options" })
map("n", "<leader>gfa", ":Git fetch origin --recurse-submodules=no --progress --prune<CR>")
map("n", "<leader>gp", ":Git push<CR>", { desc = "git push" })
map("n", "<leader>gP", ":Git push --force<CR>", { desc = "git push with force option" })
map("n", "<leader>gC", ":Telescope conventional_commits<CR>", { desc = "git conventional commit" })
map("n", "<leader>tt", ":lua ReplaceStringsWithTranslation()<CR>", { desc = "generate translation i18n syntax" })
map("n", "<leader>gtt", ":lua open_translation_file()<CR>", { desc = "go to translation" })
map("n", "ga", ":lua git_add()<CR>", { desc = "git add in tree mode" })
map('n', '<leader>S', ':lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
map('n', '<leader>sw', ':lua require("spectre").open_visual({select_word=true})<CR>', { desc = "Search current word" })
map('v', '<leader>sw', '<esc>:lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
map('n', '<leader>sp', ':lua require("spectre").open_file_search({select_word=true})<CR>', { desc = "Search on current file" })
-- Terminal
map("n", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp", size = 0.4 }
end, { desc = "Toogle Terminal Vertical" })
map("n", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp", size = 0.4 }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-]>", function()
  require("nvchad.term").toggle { pos = "vsp" }
end, { desc = "Toogle Terminal Vertical" })
map("t", "<C-\\>", function()
  require("nvchad.term").toggle { pos = "sp" }
end, { desc = "Toogle Terminal Horizontal" })
map("t", "<C-f>", function()
  require("nvchad.term").toggle { pos = "float" }
end, { desc = "Toogle Terminal Float" })
map("n", "<leader>q", ":q<CR>", { desc = "quit" })
map("n", "<leader>qq", ":q!<CR>", { desc = "!quit" })
map("n", "<leader>fd", function()
  -- print("Путь в leader fd",vim.fn.expand("%:p:h"))
  require("telescope.builtin").live_grep { cwd = vim.fn.expand("%:p:h") }
end, { desc = "Telescope find in current directory" }
)

map("n", "<leader>fif", function()
  local cwd = require("nvim-tree.api").tree.get_node_under_cursor().absolute_path
  -- print(cwd, pwd, result)
  require("telescope.builtin").live_grep { cwd = cwd }
end, { desc = "find at cursor directory" }
)

-- Генерация объекта словаря на основе директории
map("n", "<leader>god", ":lua run_node_script()<CR>", { desc = "generate i18n dictionary object" })


function run_node_script()
  -- Получите путь к директории конфигурации Neovim
  local config_path = vim.fn.stdpath('config')
  local cwd = require("nvim-tree.api").tree.get_node_under_cursor().absolute_path

  -- Укажите путь к вашему Node.js скрипту относительно директории конфигурации
  -- local script_path = config_path .. "/lua/scratches/genObj.js"  -- Замените на имя вашего скрипта
  -- не рабочая конструкция
  local script_path = config_path .. "/lua/scratches/main/main" -- Замените на имя вашего скрипта

  -- Запуск скрипта с помощью vim.fn.system и получение вывода
  -- local output = vim.fn.system("node " .. script_path .. " " .. cwd)
  -- не рабочая конструкция
  local output = vim.fn.system(script_path .. " " .. cwd)

  -- Обработка ошибок, если скрипт не выполнился
  if vim.v.shell_error ~= 0 then
    print("Error running script: " .. output)
    return
  end

  -- Создание нового буфера
  vim.cmd("tabnew")

  -- Настройка буфера как временного
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"

  vim.api.nvim_buf_set_option(0, "filetype", "javascript")
  -- Вставка вывода в новый буфер
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, "\n"))

  -- Печать уведомления
  print("Output written to new buffer")
end

-- Функция для замены строковых данных в текущей строке
function ReplaceStringsWithTranslation()
  -- Получаем имя текущего файла без расширения
  local current_file_name = vim.fn.expand('%:t:r')

  -- Приводим первую букву к строчной
  local function toLowerFirstLetter(str)
    return str:gsub("^(.)", function(c) return c:lower() end)
  end

  -- Обрабатываем текущее имя файла
  current_file_name = toLowerFirstLetter(current_file_name)

  -- Получаем номер текущей строки
  local line_number = vim.fn.line('.')
  local current_line = vim.fn.getline(line_number)

  -- Читаем весь файл в таблицу
  local lines = vim.fn.getline(1, '$')

  -- Шаблон для поиска существующих меток
  local existing_pattern = "t%('([^']+)',"

  -- Переменная для подстановки в конструкцию
  local text_mark = current_file_name -- по умолчанию

  -- Поиск ближайшей метки к текущей строке
  local closest_mark = nil
  local closest_distance = math.huge -- начальное значение - бесконечность

  for i, line in ipairs(lines) do
    line:gsub(existing_pattern, function(mark)
      -- Вычисляем расстояние до текущей строки
      local distance = math.abs(line_number - i)
      -- Проверяем, является ли эта метка ближе
      if distance < closest_distance then
        closest_distance = distance
        closest_mark = mark
      end
    end)
  end

  -- Если метка найдена, обрезаем до последней точки, если нужно
  if closest_mark then
    if closest_mark:find("%.") then
      closest_mark = closest_mark:match("(.+)%..*$") -- обрезаем до последней точки
    end
    text_mark = closest_mark                         -- обновляем text_mark
  end

  -- Определяем шаблон для поиска строковых данных
  local string_pattern = '["\'](.-)["\']'

  -- Функция для выполнения замены
  local new_line = current_line:gsub(string_pattern, function(str)
    -- Заменяем найденную строку на конструкцию t('textMark', 'string')
    return string.format("t('%s', '%s')", text_mark, str)
  end)

  -- Заменяем текущую строку на новую
  vim.fn.setline(line_number, new_line)

  -- Получаем номер текущей строки
  local lN = vim.fn.line('.')
  local cL = vim.fn.getline(lN)
  local new_cursor_position = string.find(cL, "'%,")
  vim.fn.cursor(line_number, new_cursor_position) -- Плюс 1 для установки перед "',"
  vim.cmd('startinsert')
end

function open_translation_file()
  -- Получаем текущую строку и номер строки курсора
  local current_line_num = vim.fn.line('.')
  local line = vim.fn.getline(current_line_num)

  -- Находим dictionary_name по шаблону
  local trans_pattern = "const%s*{[%s\t]*t[%s\t]*}[%s\t]*=%s*useTranslation%(['\"]([%w%.%_%-%s]+)['\"]%);"
  local dictionary_name = nil

  -- Проходим по всем строкам текущего буфера, чтобы найти dictionary_name
  for i = 1, vim.fn.line('$') do
    local search_line = vim.fn.getline(i)
    local name = search_line:match(trans_pattern)
    if name then
      dictionary_name = name
      break
    end
  end

  if not dictionary_name then
    print("Словарь не найден!")
    return
  end
  print(dictionary_name)

  -- Определяем путь для 't'
  local path = line:match("t%s*%('([^',]+)")
  if not path then
    print("Путь не найден!")
    path = ""
  end
  print("path = " .. path)

  local translation_file = dictionary_name .. ".js"

  -- Печатаем информацию об искомом файле
  print("Искомый файл перевода: " .. translation_file)

  -- Получение списка файлов из .gitignore
  local git_ignore_files = {}
  local git_ignore_path = vim.fn.getcwd() .. '/.gitignore'

  -- Чтение gitignore
  if vim.fn.filereadable(git_ignore_path) then
    for c_line in io.lines(git_ignore_path) do
      if c_line ~= '' and not c_line:match("^#") then       -- Игнорировать пустые строки и комментарии
        table.insert(git_ignore_files, c_line)
      end
    end
  end

  -- Формируем шаблон для поиска, исключая файлы из git ignore
  local search_pattern = "**/" .. translation_file
  local file_found = false
  local existing_buffer = nil

  -- Проверяем, открыт ли файл в текущих буферах
  for _, buf in ipairs(vim.fn.getbufinfo('%')) do
    if buf.name == vim.fn.expand('%:p:h') .. '/' .. translation_file then
      existing_buffer = buf.bufnr
      break
    end
  end

  -- Если файл уже открыт, переключаемся на него
  if existing_buffer then
    vim.cmd("buffer " .. existing_buffer)
    print("Файл перевода уже открыт. Переключение на него.")
    -- Переход к первому совпадению
    return
  end

  -- Если файл не открыт, продолжаем поиск
  for _, c_path in ipairs(vim.fn.glob(search_pattern, true, true)) do
    local is_ignored = false
    for _, ignored in ipairs(git_ignore_files) do
      if vim.fn.globpath(vim.fn.getcwd(), c_path):match(ignored) then
        is_ignored = true
        break
      end
    end

    if not is_ignored then
      print("Найден файл: " .. c_path)
      file_found = true

      -- Открываем файл перевода в вертикальном сплите
      vim.cmd("vsplit " .. c_path)
      -- Перейдем в конец файла после открытия
      -- vim.cmd("normal! G")
      break
    end
  end

  if not file_found then
    print("Файл перевода не найден!")
    return
  end

  -- Поиск перевода по пути. Если путь составной, ищем последний 'field'.
  local fields = {}
  for field in path:gmatch("([^%.]+)") do
    table.insert(fields, field)
  end

  local last_field = fields[#fields]

  -- Используем команду для поиска
  vim.cmd("normal! /" .. last_field .. "<CR>")

  -- Подсветка всех совпадений
  vim.fn.matchadd('Search', last_field)

  -- Переход к первому совпадению
  vim.cmd("normal! n")

  print("Открыт файл перевода, искомый путь: " .. path)
end

local api = require("nvim-tree.api")

git_add = function()
  local node = api.tree.get_node_under_cursor()
  local gs = node.git_status.file

  -- If the current node is a directory get children status
  if gs == nil then
    gs = (node.git_status.dir.direct ~= nil and node.git_status.dir.direct[1]) 
         or (node.git_status.dir.indirect ~= nil and node.git_status.dir.indirect[1])
  end

  -- If the file is untracked, unstaged or partially staged, we stage it
  if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
    vim.cmd("silent !git add " .. node.absolute_path)

  -- If the file is staged, we unstage
  elseif gs == "M " or gs == "A " then
    vim.cmd("silent !git restore --staged " .. node.absolute_path)
  end

  api.tree.reload()
end

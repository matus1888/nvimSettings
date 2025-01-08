package main

import (
 "bufio"
 "fmt"
 "os"
 "path/filepath"
 "strings"
)

type Result struct {
 Path  string
 Value string
}

var results []Result

// Для представления результирующего объекта
type ResObj map[string]interface{}

func main() {
 var folder string
 // Если аргументы командной строки не указаны, используем текущую директорию
 if len(os.Args) < 2 {
  folder, _ = os.Getwd() // Получаем текущую директорию
 } else {
  folder = os.Args[1]
 }

 // Запускаем поиск файлов
 searchFiles(folder, "t(", "t<string>(")

 // Фильтрация результатов
 filterResults()

 // Создание результирующего объекта
 resObj := createResultObject()

 // Вывод результата в JavaScript-подобном формате
 fmt.Println("const res = {")
 printResObj(resObj, 1) // Убираем начальный отступ
 fmt.Println("};")
}

func printResObj(obj ResObj, indent int) {
 indentation := strings.Repeat("  ", indent) // Создаем отступ
 for key, value := range obj {
  switch v := value.(type) {
  case string:
   fmt.Printf("%s%s: \"%s\",\n", indentation, key, v) // Убираем кавычки вокруг ключа
  case ResObj:
   fmt.Printf("%s%s: {\n", indentation, key)
   printResObj(v, indent+1) // Рекурсивный вызов для вложенных объектов
   fmt.Printf("%s},\n", indentation)
  }
 }
}

func searchFiles(directoryPath, searchPattern1, searchPattern2 string) {
 err := filepath.Walk(directoryPath, func(filePath string, info os.FileInfo, err error) error {
  if err != nil {
   return err
  }
  if !info.IsDir() {
   return processFile(filePath, searchPattern1, searchPattern2)
  }
  return nil
 })
 if err != nil {
  fmt.Printf("Error walking the path %v: %v\n", directoryPath, err)
 }
}

func processFile(filePath, searchPattern1, searchPattern2 string) error {
 file, err := os.Open(filePath)
 if err != nil {
  return err
 }
 defer file.Close()

 scanner := bufio.NewScanner(file)
 var fileContent string
 for scanner.Scan() {
  line := scanner.Text()
  fileContent += line + "\n"
 }

 if strings.Contains(fileContent, searchPattern1) || strings.Contains(fileContent, searchPattern2) {
  searchAll(fileContent)
 }

 return scanner.Err()
}

func searchAll(fileContent string) {
 // Поиск строк с шаблоном "t("
 contents := extractStrings(fileContent, "t('")
 results = append(results, contents...)

 // Поиск строк с шаблоном "t<string>('"
 contents = extractStrings(fileContent, "t<string>('")
 results = append(results, contents...)
}

func extractStrings(fileContent, template string) []Result {
 lines := strings.Split(fileContent, "\n")
 var extractedResults []Result

 for _, line := range lines {
	 // TODO следующий паттернт используется для обработки исключений: по необходимости нужно добавить другие исключения
  line = strings.TrimSpace(strings.ReplaceAll(line, "moment(", ""))
  if strings.Contains(line, template) {
   parts := strings.Split(line, template)
   for _, part := range parts[1:] {
    value := strings.Split(part, "')")[0]
    counts := strings.Split(strings.ReplaceAll(value, "'", ""), ",")
    if len(counts) >= 2 {
     path := strings.TrimSpace(counts[0])
     val := strings.TrimSpace(counts[1])
     extractedResults = append(extractedResults, Result{Path: path, Value: val})
    }
   }
  }
 }
 return extractedResults
}

func filterResults() {
 for i := 0; i < len(results); i++ {
  if results[i].Path == ";" || results[i].Path == "" || results[i].Value == "" {
   results = append(results[:i], results[i+1:]...)
   i--
  }
 }
}

func createResultObject() ResObj {
 resObj := make(ResObj)
 for _, result := range results {
  // Разбор пути на ключи
  keys := strings.Split(result.Path, ".")
  cur := resObj

  // Строим вложенные объекты для ключей с точками
  for i, key := range keys {
   if i == len(keys)-1 {
    cur[key] = result.Value
   } else {
    if _, ok := cur[key]; !ok {
     cur[key] = make(ResObj) // создаем новый объект, если он не существует
    }
    // Осуществляем кастинг к ResObj
    cur = cur[key].(ResObj)
   }
  }
 }
 return resObj
}

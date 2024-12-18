const fs = require("fs");
const path = require("path");
const folder = process.argv[2]

// Функция для сканирования директории и поиска строк по заданному шаблону
function searchFiles(directoryPath, searchPattern, searchPattern2) {
  // Сканируем директорию, используя синхронный метод readdirSync
  const fileNames = fs.readdirSync(directoryPath);

  // Для каждого имени файла проверяем, является ли он директорией
  for (const fileName of fileNames) {
    const filePath = path.join(directoryPath, fileName);
    const stats = fs.statSync(filePath);

    if (stats.isDirectory()) {
      // Если файл является директорией, рекурсивно вызываем эту же функцию с новым путем
      searchFiles(filePath, searchPattern, searchPattern2);
    } else {
      // Если файл не является директорией, открываем его и ищем строки по заданному шаблону
      const fileContent = fs.readFileSync(filePath, { encoding: "utf-8" });

      if (
        fileContent.includes(searchPattern) ||
        fileContent.includes(searchPattern2)
      ) {
        // console.log(`Найден шаблон в файле "${filePath}"`);
        searchAll(fileContent);
      }
    }
  }
}

let result = [];

function searchAll(fileContent) {
  fileContent
    ?.split("\n")
    ?.map((i) => i?.trim().replaceAll('moment(','' ))
    .join("")
    .split("t('")
    ?.slice(1)
    ?.map((i) => i.split("')")?.[0])
    .map((str) => {
      const counts = str.replaceAll("'", "").split(",");
      return {
        path: counts?.[0]?.trim(),
        value: counts?.[1]?.trim(),
      };
    })
    .filter(Boolean)
    .forEach((item) => result.push(item));
  fileContent
    ?.split("\n")
    ?.map((i) => i?.trim().replaceAll('moment(','' ))
    .join("")
    .split("t<string>('")
    ?.slice(1)
    ?.map((i) => i.split("')")?.[0])
    .map((str) => {
      const counts = str.replaceAll("'", "").split(",");
      return {
        path: counts?.[0]?.trim(),
        value: counts?.[1]?.trim(),
      };
    })
    .filter(Boolean)
    .forEach((item) => result.push(item));
}

// console.log(folder)
searchFiles(
  folder ||
    "C:\\dev\\doubleWorkspace\\workspace\\packages\\shared\\Documents\\ReportReweighing",
  "t(",
  "t<string>(",
);
let resObj = {};

//todo тут выкинь то что лишнее по path или value
result = result
  .filter((item) => item.path !== ";")
  .filter((item) => item.path )
  .filter((item) => item.value);

setTimeout(() => {
  // console.log(
  //   result.map((item) => `'${item.path}': '${item.value}'`)?.join(",\n"),
  // );
  result.forEach(({ path }) => {
    generateStruct(path, resObj);
  });
  result.forEach(({ path, value }) => {
    eval(`resObj.${path} = value`);
  });
  console.log('const res = ')
  console.dir(resObj, { depth: null });
}, 5000);

function generateStruct(path) {
  const items = path.split(".");
  items.forEach((item, index) => {
    // console.log(item);
    const pathToItem = path.split(".").slice(0, index).join(".");
    if (pathToItem) {
      const evalStr = `(resObj.${pathToItem.split(".").join("?.")})`;
      const val = eval(evalStr);
      if (typeof val !== "object") {
        eval(`resObj.${pathToItem} = {}`);
      }
      // console.log({
      //   item,
      //   pathToItem,
      //   evalStr,
      //   val
      // });
    }
  });
}

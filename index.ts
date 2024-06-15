import * as mysql from "mysql2";
import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";

dotenv.config();

const EXPORT_PATH = "./export";

const checkDir = (path: string) => {
  if (!fs.existsSync(path)) {
    fs.mkdirSync(path);
  }
};

const handleExport = (dbName: string) => {
  const conn = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: Number(process.env.DB_PORT || 3306),
    database: dbName,
  });

  conn.connect((err) => {
    if (err) throw err;
    console.log(`Database ${dbName} is connected!`);

    checkDir(EXPORT_PATH);

    conn.query(
      "SHOW TABLES",
      (err, tables: Array<Record<`Tables_in_${string}`, string>>) => {
        if (err) throw err;

        tables.forEach((table) => {
          const tableName = table[`Tables_in_${dbName}`];
          conn.query(`SELECT * from ${tableName}`, (err, result) => {
            if (err) throw err;

            const jsonData = JSON.stringify(result, null, 2);
            const filePath = path.join(
              EXPORT_PATH,
              `${dbName}/${tableName}.json`
            );

            checkDir(path.join(EXPORT_PATH, dbName));
            fs.writeFileSync(filePath, jsonData);

            console.log(
              `Table ${tableName} successfully exported to ${filePath}`
            );
          });
        });

        conn.end();
      }
    );
  });
};

const databases = ["uts_events", "uts_events_live"];
databases.forEach((db) => {
  handleExport(db);
});

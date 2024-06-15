## EXPORT MYSQL

Tech Stack:

- TypeScript
- MySQL

### INSTALLATION

```
yarn install
```

### SETUP

1. Import database terlebih dahulu yang ada di folder `sql`, bisa menggunakan phpmyadmin atau tools database lainnya.
2. Buat file `.env` di root folder (sejajar dengan file `index.ts`), variables key-nya ikuti apa yang ada di file `env.example`.

### RUN EXPORT

```
yarn export
```

Hasil export akan ada dalam folder `export`.

# 🍽️ API REST - Sistema de Reservaciones de Restaurante

![Node.js](https://img.shields.io/badge/Node.js-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?style=for-the-badge&logo=express&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)
![JWT](https://img.shields.io/badge/JWT-000000?style=for-the-badge&logo=JSON%20web%20tokens&logoColor=white)
![Swagger](https://img.shields.io/badge/Swagger-85EA2D?style=for-the-badge&logo=Swagger&logoColor=black)

API RESTful backend construida con Node.js y Express para gestionar de manera integral el sistema de reservaciones de un restaurante. Cuenta con prevención inteligente de conflictos de horarios (double-booking), autenticación JWT y acceso basado en roles.

---

## ✨ Características Principales

* **Autenticación Segura (JWT):** Registro e inicio de sesión encriptado con Bcrypt. Control de acceso mediante roles (`admin` y `cliente`).
* **Gestión de Mesas (CRUD):** Los administradores pueden añadir, actualizar y dar de baja mesas. Implementa "Soft Delete" para mantener la integridad histórica.
* **Sistema de Reservaciones Anti-Colisión:** Algoritmo que valida intersecciones de tiempo y fechas antes de confirmar una reserva, garantizando que una mesa no se asigne a dos personas al mismo tiempo.
* **ORM Moderno:** Integrado 100% con **Prisma ORM**, brindando tipado seguro, prevención de inyecciones SQL y un modelado de datos declarativo.
* **Documentación Interactiva:** Documentado exhaustivamente usando Swagger UI.

---

## 🚀 Requisitos Previos

Asegúrate de tener instalado en tu máquina:
- [Node.js](https://nodejs.org/es/) (v16+)
- [MySQL](https://www.mysql.com/) (v8+)

---

## 🛠️ Instalación y Configuración

Sigue estos pasos para arrancar el entorno de desarrollo local:

1. **Clona el repositorio e instala las dependencias:**
   ```bash
   npm install
   ```

2. **Configura las variables de entorno:**
   - Duplica el archivo `.env.example` y renómbralo a `.env`.
   - Reemplaza los valores de tu conexión local de base de datos MySQL. En especial, asegúrate de configurar el `DATABASE_URL` para Prisma:
   ```env
   # Ejemplo de configuración
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=tu_contraseña_aqui
   DB_NAME=restaurante_db
   DB_PORT=3306

   # Configuración de Prisma
   DATABASE_URL="mysql://root:tu_contraseña_aqui@localhost:3306/restaurante_db"
   ```

3. **Sincroniza la Base de Datos:**
   Prisma se encargará de crear las tablas por ti sin necesidad de scripts manuales:
   ```bash
   npx prisma db push
   ```
   *(Nota: si necesitas semillas de base de datos, el archivo `database/schema.sql` contiene los INSERTS iniciales de mesas y un usuario admin por defecto que puedes correr manualmente en tu gestor SQL).*

4. **Levanta el servidor en modo desarrollo:**
   ```bash
   npm run dev
   ```

El servidor arrancará en `http://localhost:3000`.

---

## 📖 Documentación de la API (Swagger)

La API cuenta con una interfaz gráfica interactiva gracias a Swagger, donde podrás probar todos los endpoints y visualizar los esquemas esperados.

Para acceder, una vez levantado el servidor, dirígete a:
👉 **[http://localhost:3000/api-docs](http://localhost:3000/api-docs)**

### Principales Endpoints:
- `POST /api/auth/login`: Para obtener tu token JWT.
- `GET /api/mesas`: Listar catálogo de mesas.
- `POST /api/reservaciones`: Crear una reservación (requiere Token de Cliente).

---

## 🧱 Arquitectura del Proyecto

El proyecto sigue el patrón **MVC (Model-View-Controller)** adaptado para APIs modernas.
- **`/prisma`**: Contiene `schema.prisma` (la fuente de verdad de la base de datos).
- **`/src/routes`**: Define las rutas web y las protege con middlewares.
- **`/src/middlewares`**: Interceptores como `auth.middleware` para validar tokens.
- **`/src/controllers`**: Toda la lógica dura del negocio, conectándose directamente con la base de datos a través de Prisma Client.
- **`/src/config`**: Configuraciones generales (Swagger, Variables globales).

---
*Proyecto de ejemplo para sistema de reservaciones de restaurante.*

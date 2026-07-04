-- ============================================================
-- ESQUEMA DE BASE DE DATOS: Restaurante Reservaciones
-- Motor: MySQL 8.0+
-- ============================================================
-- INSTRUCCIONES:
--   1. Abre MySQL Workbench o tu cliente preferido
--   2. Ejecuta este script completo
--   3. La base de datos 'restaurante_db' quedará lista
-- ============================================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS restaurante_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE restaurante_db;

-- ============================================================
-- TABLA: usuarios
-- Almacena clientes y administradores del sistema.
-- El campo 'rol' distingue entre 'cliente' y 'admin'.
-- ============================================================
CREATE TABLE IF NOT EXISTS usuarios (
    id            INT           AUTO_INCREMENT PRIMARY KEY,
    nombre        VARCHAR(100)  NOT NULL,
    correo        VARCHAR(150)  NOT NULL UNIQUE,   -- único para login
    password_hash VARCHAR(255)  NOT NULL,           -- contraseña cifrada con bcrypt
    rol           ENUM('cliente', 'admin') NOT NULL DEFAULT 'cliente',
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: mesas
-- Catálogo de mesas físicas del restaurante.
-- El admin puede agregar, editar y desactivar mesas.
-- ============================================================
CREATE TABLE IF NOT EXISTS mesas (
    id            INT           AUTO_INCREMENT PRIMARY KEY,
    numero        INT           NOT NULL UNIQUE,     -- número visible en el restaurante
    capacidad     INT           NOT NULL,            -- cuántas personas caben
    ubicacion     VARCHAR(100)  DEFAULT 'Salón principal', -- ej: 'Terraza', 'VIP', 'Jardín'
    activa        BOOLEAN       DEFAULT TRUE,        -- FALSE = mesa fuera de servicio
    created_at    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: reservaciones
-- Corazón del sistema: vincula usuarios con mesas en un horario.
-- ============================================================
CREATE TABLE IF NOT EXISTS reservaciones (
    id                INT           AUTO_INCREMENT PRIMARY KEY,
    usuario_id        INT           NOT NULL,
    mesa_id           INT           NOT NULL,
    fecha             DATE          NOT NULL,         -- ej: 2026-07-15
    hora_inicio       TIME          NOT NULL,         -- ej: 19:00:00
    hora_fin          TIME          NOT NULL,         -- ej: 21:00:00
    num_personas      INT           NOT NULL,         -- para verificar contra capacidad
    estado            ENUM('pendiente', 'confirmada', 'cancelada', 'completada')
                                    NOT NULL DEFAULT 'pendiente',
    notas             TEXT          DEFAULT NULL,     -- solicitudes especiales del cliente
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- Llaves foráneas: garantizan integridad referencial
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (mesa_id)    REFERENCES mesas(id)    ON DELETE CASCADE
);

-- ============================================================
-- ÍNDICES DE RENDIMIENTO
-- Aceleran las consultas más frecuentes
-- ============================================================
-- Buscar reservaciones por fecha y mesa (para detectar conflictos)
CREATE INDEX idx_reservaciones_fecha_mesa
    ON reservaciones (fecha, mesa_id);

-- Buscar reservaciones de un usuario específico
CREATE INDEX idx_reservaciones_usuario
    ON reservaciones (usuario_id);

-- ============================================================
-- DATOS INICIALES (Seed)
-- ============================================================

-- Admin por defecto (contraseña: Admin123! — hash de bcrypt)
INSERT IGNORE INTO usuarios (nombre, correo, password_hash, rol)
VALUES (
    'Administrador',
    'admin@restaurante.com',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- Admin123!
    'admin'
);

-- Mesas del restaurante
INSERT IGNORE INTO mesas (numero, capacidad, ubicacion) VALUES
    (1,  2, 'Terraza'),
    (2,  2, 'Terraza'),
    (3,  4, 'Salón principal'),
    (4,  4, 'Salón principal'),
    (5,  4, 'Salón principal'),
    (6,  6, 'Salón principal'),
    (7,  6, 'VIP'),
    (8,  8, 'VIP'),
    (9,  2, 'Jardín'),
    (10, 4, 'Jardín');

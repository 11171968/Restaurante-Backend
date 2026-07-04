const swaggerJsdoc = require('swagger-jsdoc');

const spec = swaggerJsdoc({
    failOnErrors: true, // Esto debería lanzar la excepción real
    definition: { openapi: '3.0.0', info: { title: 'Test', version: '1.0.0' } },
    apis: ['./src/routes/auth.routes.js']
});
console.log('OK');

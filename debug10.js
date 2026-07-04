const fs = require('fs');
const doctrine = require('doctrine');

const fileContent = fs.readFileSync('src/routes/auth.routes.js', 'utf8');
const jsDocRegex = /\/\*\*([\s\S]*?)\*\//gm;
const regexResults = fileContent.match(jsDocRegex) || [];

regexResults.forEach((annotation, i) => {
    try {
        const jsDocComment = doctrine.parse(annotation, { unwrap: true });
        for (const tag of jsDocComment.tags) {
            if (tag.title === 'swagger' || tag.title === 'openapi') {
                console.log(`Block ${i} snippet:`, annotation.substring(0, 50).replace(/\n/g, ' '));
                console.log(`Block ${i}:`, tag.description === null ? 'NULL' : 'OK');
            }
        }
    } catch(e) {}
});

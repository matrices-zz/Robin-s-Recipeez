const http = require('http');
const url = require('url');
const axios = require('axios');
const cheerio = require('cheerio');

function extractRecipe(html, sourceUrl) {
    const $ = cheerio.load(html);
    const title = $('h1').first().text().trim() || 'Untitled Recipe';
    const ingredients = [];
    $('ul li').each((i, el) => {
        const txt = $(el).text().trim();
        if (txt) ingredients.push(txt);
    });
    const steps = [];
    $('ol li').each((i, el) => {
        const txt = $(el).text().trim();
        if (txt) steps.push(txt);
    });
    const img = $('img').first().attr('src') || '';
    return { title, ingredients, steps, image: img, sourceUrl };
}

http.createServer(async (req, res) => {
    const query = url.parse(req.url, true).query;
    const target = query.url;
    if (!target) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Missing ?url parameter' }));
        return;
    }
    try {
        const response = await axios.get(target);
        const recipe = extractRecipe(response.data, target);
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(recipe));
    } catch (e) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: e.message }));
    }
}).listen(5080, () => {
    console.log('Recipe scraper listening on port 5080');
});

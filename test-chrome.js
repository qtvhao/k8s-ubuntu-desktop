let puppeteer = require('puppeteer');
let fs = require('fs');
(async () => {
    let connection = await puppeteer.connect({
        browserURL: 'http://chrome:21223',
    });
    let page = await connection.newPage();
    await page.goto('https://www.google.com');
    await page.screenshot({ path: 'screenshot.png' });
    await page.pdf({ path: 'page.pdf' });
    await page.close();
})();

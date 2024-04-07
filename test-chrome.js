let puppeteer = require('puppeteer');
(async () => {
    let browser;
    while (true) {
        let browserURL = 'http://203.0.117.3:21223';
        let fetched;
        console.log('Trying to connect to browser, browserURL:', browserURL);
        try {
            fetched = await fetch(browserURL + '/json/version');
        }catch(e) {
            console.log('Waiting for browser, browserURL:', browserURL);
            await new Promise(resolve => setTimeout(resolve, 1000));
            continue;
        }
        try {
            browser = await puppeteer.connect({
                browserURL,
            });
            break;
        } catch(e) {
            console.log('Waiting for browser, browserURL:', browserURL);
            await new Promise(resolve => setTimeout(resolve, 1000));
            continue;
        }
    }
    console.log('Connected to browser');
    let page = await browser.newPage();
    await page.goto('https://www.google.com');
    console.log('Page loaded');
    await page.screenshot({ path: '/screenshot.png' });
    await page.pdf({ path: '/page.pdf' });
    console.log('Screenshot and PDF saved');
    await page.close();
    browser.close();
    console.log('Page closed');
})();

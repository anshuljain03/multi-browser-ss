const { Builder, By, Key, until } = require('selenium-webdriver'),
    async = require('async'),
    fs = require('fs'),

    /**
     * Takes a screenshot of a given site in the specified browser environment
     *
     * @param {String} url - The website url
     * @param {String} browser  - Browser environment to use eg. chrome, firefox etc
     * @param {String} host - Server on which the browser is running
     *
     */
    takeScreenshot = async function (url, browser, host) {
        let driver = new Builder().usingServer(host).forBrowser(browser).build();

        try {
            await driver.get(url);
            await driver.sleep(2000);
            await driver.takeScreenshot().then(function (data) {
                let base64Data = data.replace(/^data:image\/png;base64,/, "")
                fs.writeFile(`${browser}.png`, base64Data, 'base64', function (err) {
                    if (err) console.error(err);
                });
            });
        } finally {
            await driver.quit();
        }
    },

    /**
     * Tries to validate and return a valid url
     *
     * @param {String} url - The website url
     */
    validateUrl = function (url) {
        let validPrefixes = ['http://', 'https://'],
            validUrl = false;

        validPrefixes.forEach(function (validPrefix) {
            if (url.startsWith(validPrefix)) {
                validUrl = true;
            }
        })

        return validUrl ? url : `https://${url}`;
    },

    url = validateUrl(process.env.URL);

async.parallel([
    async.apply(takeScreenshot, url, 'chrome', 'http://localhost:4444/wd/hub'),
    async.apply(takeScreenshot, url, 'firefox', 'http://localhost:4443/wd/hub')
], function (err) {
        if (err) {
            console.error(err);
        }

        return;
})

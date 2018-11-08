import { defineSupportCode } from 'cucumber';
import { browser, by, element } from 'protractor';
import * as chai from 'chai';
import * as cap from 'chai-as-promised';
chai.use(cap);
const expect = chai.expect;

defineSupportCode(async ({ Before, Given, Then }) => {
  Before({ timeout: 30000 }, async function() {
    browser.ignoreSynchronization = true;
    await browser.get(browser.baseUrl);
  });

  Given(/^he is on "([^"]*)"$/, async function(url: string): Promise<void> {
    const currentUrl = await browser.getCurrentUrl();
    expect(currentUrl).to.equal(`${browser.baseUrl}${url}`);
  });

  Then(/^he get title "([^"]*)"$/, async function(title: string): Promise<void> {
    const currentTitle = await browser.getTitle();
    expect(currentTitle).to.equal(title);
  });
});
